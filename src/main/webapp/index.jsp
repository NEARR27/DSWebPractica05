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
    
    <h2>Crear Registro</h2>
    <form method="post" action="index.jsp">
        Clave: <input type="number" name="clave" required><br>
        Nombre: <input type="text" name="nombre" required><br>
        Dirección: <input type="text" name="direccion"><br>
        Teléfono: <input type="text" name="telefono"><br>
        <input type="submit" name="crear" value="Crear">
    </form>
    
    <h2>Actualizar Registro</h2>
    <form method="post" action="index.jsp">
        Clave a actualizar: <input type="number" name="clave_actualizar" required><br>
        Nuevo Nombre: <input type="text" name="nuevo_nombre"><br>
        Nueva Dirección: <input type="text" name="nueva_direccion"><br>
        Nuevo Teléfono: <input type="text" name="nuevo_telefono"><br>
        <input type="submit" name="actualizar" value="Actualizar">
    </form>
    
    <h2>Eliminar Registro</h2>
    <form method="post" action="index.jsp">
        Clave a eliminar: <input type="number" name="clave_eliminar" required><br>
        <input type="submit" name="eliminar" value="Eliminar">
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
            
            if (request.getParameter("crear") != null) {
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
            }
            
            if (request.getParameter("actualizar") != null) {
                int clave_actualizar = Integer.parseInt(request.getParameter("clave_actualizar"));
                String nuevo_nombre = request.getParameter("nuevo_nombre");
                String nueva_direccion = request.getParameter("nueva_direccion");
                String nuevo_telefono = request.getParameter("nuevo_telefono");
                
                PreparedStatement pstmt = conn.prepareStatement("UPDATE ejemplo SET nombre=?, direccion=?, telefono=? WHERE clave=?");
                pstmt.setString(1, nuevo_nombre);
                pstmt.setString(2, nueva_direccion);
                pstmt.setString(3, nuevo_telefono);
                pstmt.setInt(4, clave_actualizar);
                pstmt.executeUpdate();
                pstmt.close();
            }
            
            if (request.getParameter("eliminar") != null) {
                int clave_eliminar = Integer.parseInt(request.getParameter("clave_eliminar"));
                
                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM ejemplo WHERE clave=?");
                pstmt.setInt(1, clave_eliminar);
                pstmt.executeUpdate();
                pstmt.close();
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
