<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
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
        <input type="submit" name="accion" value="Actualizar">
    </form>
    
    <h2>Eliminar Registro</h2>
    <form method="post" action="index.jsp">
        Clave a eliminar: <input type="number" name="clave_eliminar" required><br>
        <input type="submit" name="accion" value="Eliminar">
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
        String url = "jdbc:postgresql://172.17.0.2:5432/mydb";
        String user = "postgres";
        String password = "postgres"; // Reemplaza con tu contraseña

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            String accion = request.getParameter("accion");
            
            if (accion != null) {
                if (accion.equals("Crear")) {
                    int clave = Integer.parseInt(request.getParameter("clave"));
                    String nombre = request.getParameter("nombre");
                    String direccion = request.getParameter("direccion");
                    String telefono = request.getParameter("telefono");
                    
                    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO ejemplo (clave, nombre, direccion, telefono) VALUES (?, ?, ?, ?)");
                    pstmt.setInt(1, clave);
                    pstmt.setString(2, nombre);
                    pstmt.setString(3, direccion);
                    pstmt.setString(4, telefono);
                    pstmt.executeUpdate();
                    pstmt.close();
                } else if (accion.equals("Actualizar")) {
                    int clave_actualizar = Integer.parseInt(request.getParameter("clave"));
                    String nuevo_nombre = request.getParameter("nombre");
                    String nueva_direccion = request.getParameter("direccion");
                    String nuevo_telefono = request.getParameter("telefono");
                    
                    PreparedStatement pstmt = conn.prepareStatement("UPDATE ejemplo SET nombre=?, direccion=?, telefono=? WHERE clave=?");
                    pstmt.setString(1, nuevo_nombre);
                    pstmt.setString(2, nueva_direccion);
                    pstmt.setString(3, nuevo_telefono);
                    pstmt.setInt(4, clave_actualizar);
                    pstmt.executeUpdate();
                    pstmt.close();
                } else if (accion.equals("Eliminar")) {
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
</body>
</html>
