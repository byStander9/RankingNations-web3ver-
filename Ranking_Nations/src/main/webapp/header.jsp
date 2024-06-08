<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<style>
		.navbar {
			background-color: #1a1a2e;
			color: white;
			padding: 2% 0 2% 2%;
			display: flex;
			justify-content: space-between;
			align-items: center;
			height: 10%;
			width: 98%;
		}
		.navbar a {
		    color: white;
		    text-decoration: none;
		}
		
	    .menu{
	    	width: 18%;
	    	display: flex;
	    }
	    .menu div {
	    	padding-right: 5%;
	    }
		.dropdown {
		    position: relative;
		    display: inline-block;
		}
		
		.dropdown-content {
		    display: none;
		    position: absolute;
		    background-color: #f9f9f9;
		    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		    white-space: nowrap;
		}
		
		.dropdown-content a {
		    color: black;
		    padding: 12px 16px;
		    text-decoration: none;
		    display: block;
		}
		
		.dropdown-content a:hover {background-color: #f1f1f1}
		
		.show {display:block;}
   </style>
   
   <script>
	   // 드롭다운을 보여주는 함수
		function showDropdown() {
		    document.getElementById("myDropdown").classList.add("show");
		}
		
		// 드롭다운을 숨기는 함수
		function hideDropdown() {
		    document.getElementById("myDropdown").classList.remove("show");
		}
	</script>
</head>
<body>
	<div class="navbar">
        <div class="logo"><a href="main.jsp">Acme Inc</a></div>
        <div class="menu">
            <div class="dropdown" onmouseover="showDropdown()" onmouseout="hideDropdown()">
			    <a href="#">category</a>
			    <div class="dropdown-content" id="myDropdown">
			        <a href="vote.jsp?category=clothes">의복</a>
			        <a href="#">링크 2</a>
			        <a href="#">링크 3</a>
	    		</div>
			</div>
         	<div><a href="#">Comment Board</a></div>
           	<div><a href="#">myPage</a></div>
        </div>
    </div>
</body>
</html>