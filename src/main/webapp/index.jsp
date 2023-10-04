<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.naming.InitialContext, javax.naming.Context, javax.sql.DataSource" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRUD Ejemplo</title>   
</head>
<body>
    <h1>CRUD Ejemplo</h1>

    <h2>Crear/Actualizar Registro</h2>
    <form method="post" action="index.jsp">
        Clave: <input type="number" name="clave" required><br>
        Nombre: <input type="text" name="nombre" required><br>
        Dirección: <input type="text" name="direccion"><br>
        Teléfono: <input type="text" name="telefono"><br>
        <input type="submit" name="accion" value="Crear">
        <input type="hidden" name="operacion" value="Crear"> <!-- Nuevo campo oculto para la acción -->
    </form>

    <h2>Eliminar Registro</h2>
    <form method="post" action="index.jsp">
        Clave a eliminar: <input type="number" name="clave_eliminar" required><br>
        <input type="submit" name="accion" value="Eliminar">
        <input type="hidden" name="operacion" value="Eliminar"> <!-- Nuevo campo oculto para la acción -->
    </form>

    

    <h2>Registros</h2>
    <table border="1">
        <tr>
            <th>Clave</th>
            <th>Nombre</th>
            <th>Dirección</th>
            <th>Teléfono</th>
            
        </tr>
        <%
            try {
                Context initContext = new InitialContext();
                Context envContext = (Context) initContext.lookup("java:comp/env");
                DataSource dataSource = (DataSource) envContext.lookup("jdbc/mydb");

                Connection conn = dataSource.getConnection();

                String operacion = request.getParameter("operacion");

                if (operacion != null && !operacion.isEmpty()) {
                    if (operacion.equals("Crear")) {
                        int clave = Integer.parseInt(request.getParameter("clave"));
                        String nombre = request.getParameter("nombre");
                        String direccion = request.getParameter("direccion");
                        String telefono = request.getParameter("telefono");

                        // Verifica si la clave ya existe en la base de datos antes de insertar
                        PreparedStatement pstmtCheck = conn.prepareStatement("SELECT COUNT(*) FROM ejemplo WHERE clave = ?");
                        pstmtCheck.setInt(1, clave);
                        ResultSet rsCheck = pstmtCheck.executeQuery();
                        rsCheck.next();
                        int count = rsCheck.getInt(1);
                        pstmtCheck.close();

                        if (count == 0) {
                            // La clave no existe, inserta un nuevo registro
                            PreparedStatement pstmtInsert = conn.prepareStatement("INSERT INTO ejemplo (clave, nombre, direccion, telefono) VALUES (?, ?, ?, ?)");
                            pstmtInsert.setInt(1, clave);
                            pstmtInsert.setString(2, nombre);
                            pstmtInsert.setString(3, direccion);
                            pstmtInsert.setString(4, telefono);
                            pstmtInsert.executeUpdate();
                            pstmtInsert.close();
                        } else {
                            // La clave ya existe, realiza una actualización
                            PreparedStatement pstmtUpdate = conn.prepareStatement("UPDATE ejemplo SET nombre=?, direccion=?, telefono=? WHERE clave=?");
                            pstmtUpdate.setString(1, nombre);
                            pstmtUpdate.setString(2, direccion);
                            pstmtUpdate.setString(3, telefono);
                            pstmtUpdate.setInt(4, clave);
                            pstmtUpdate.executeUpdate();
                            pstmtUpdate.close();
                        }
                    } else if (operacion.equals("Eliminar")) {
                        int clave_eliminar = Integer.parseInt(request.getParameter("clave_eliminar"));

                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM ejemplo WHERE clave=?");
                        pstmt.setInt(1, clave_eliminar);
                        pstmt.executeUpdate();
                        pstmt.close();
                    }
                }

                PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM ejemplo");
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("clave") + "</td>");
                    out.println("<td>" + rs.getString("nombre") + "</td>");
                    out.println("<td>" + rs.getString("direccion") + "</td>");
                    out.println("<td>" + rs.getString("telefono") + "</td>");
                    
                    out.println("</tr>");
                }

                rs.close();
                pstmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
    <br>

    <form method="post" action="login.jsp">
        <input type="submit" value="Logout">
    </form>

    <script type="text/javascript">
        function eliminarRegistro(clave) {
            console.log("Eliminando registro con clave: " + clave);

            if (confirm("¿Estás seguro de que deseas eliminar este registro?")) {
                // Envía una solicitud AJAX para eliminar el registro
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "index.jsp", true);
                xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            console.log("Registro eliminado con éxito.");
                            // Recarga la página después de eliminar el registro
                            location.reload();
                        } else {
                            console.log("Error al eliminar el registro.");
                            // Manejar el error aquí si es necesario
                        }
                    }
                };
                xhr.send("operacion=Eliminar&clave_eliminar=" + clave);
            }
        }
    </script>
</body>
</html>
