<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acme Inc</title>
   	<style>
       body {
           font-family: Arial, sans-serif;
           margin: 0;
           padding: 0;
           background-color: #f5f5f5;
       }
       
       .main-content {
           text-align: center;
           padding: 50px 20px;
       }
       .main-content h1 {
           font-size: 36px;
           color: #333;
       }
       .main-content p {
           font-size: 18px;
           color: #666;
       }
       .products {
           display: flex;
           justify-content: center;
           margin: 20px 0;
       }
       .product {
           width: 200px;
           height: 150px;
           background-color: #ddd;
           margin: 0 10px;
           display: flex;
           justify-content: center;
           align-items: center;
           font-size: 24px;
           color: #aaa;
       }
       .sidebar {
           display: flex;
           justify-content: space-around;
           margin: 20px;
       }
       .sidebar div {
           background-color: #f0f0f0;
           padding: 20px;
           width: 200px;
       }
       .sidebar a {
           color: #333;
           text-decoration: none;
       }
       
	</style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    
    <div class="main-content">
        <h1>Discover the Best Products</h1>
        <p>Browse through our wide selection of high-quality products and find the perfect one for you.</p>
        
        <div class="products">
            <div class="product">Image</div>
            <div class="product">Image</div>
            <div class="product">Image</div>
        </div>
        
        <div class="sidebar">
            <div>
                <h3>Category Selection</h3>
                <a href="#">Category 1</a><br>
                <a href="#">Category 2</a><br>
                <a href="#">Category 3</a>
            </div>
            <div>
                <h3>Comment Board</h3>
                <a href="#">Check out the latest comments and discussions.<br>View Comment Board</a>
            </div>
            <div>
                <h3>myPage</h3>
                <a href="#">Manage your account and settings.<br>Go to myPage</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp"/>
</body>
</html>