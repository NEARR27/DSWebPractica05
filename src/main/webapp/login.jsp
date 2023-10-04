<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
</head>
<body>
    <h1>Iniciar Sesión</h1>
    
     <h1>Iniciar Sesión</h1>
        <form method="post" action="index.jsp">
            Nombre de Usuario: <input type="text" name="username" required><br>
            Contraseña: <input type="password" name="password" required><br>
            <input type="submit" value="Iniciar Sesión">
        </form>
    
    <% 
        String url = "jdbc:postgresql://172.17.0.2:5432/mydb";
        String user = "postgres";
        String password = "postgres";
        
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);

            if (request.getMethod().equals("POST")) {
                String nombreUsuario = request.getParameter("username");
                String contrasena = request.getParameter("password");


                PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM usuarios WHERE nombre_usuario=? AND contrasena=?");
                pstmt.setString(1, nombreUsuario);
                pstmt.setString(2, contrasena);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    // Usuario autenticado correctamente, puedes redirigirlo a una página de inicio.
                    response.sendRedirect("index.jsp");
                } else {
                    out.println("<p>Nombre de usuario o contraseña incorrectos. Intenta de nuevo.</p>");
                }

                rs.close();
                pstmt.close();
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
     
</body>
</html>
