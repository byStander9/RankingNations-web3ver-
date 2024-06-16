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
		
		html, body {
			font-family: Arial, sans-serif;
			margin: 0;
			padding: 0;
			background-color: #f5f5f5;
			overflow-x: hidden;
			justify-content: center; /* 슬라이더를 중앙으로 정렬 */
			align-items: center;
		}
       
       .main-content {
           text-align: center;
	        justify-content: center;
	        align-items: center;
	        width: 100%;
	        height: 80%;
	        padding: 3% 0 12px 0;
       }
       .main-content h1 {
           font-size: 36px;
           color: #333;
       }
       .main-content p {
           font-size: 18px;
           color: #666;
       }
       .sidebar {
       		align-items: center;
	       justify-content: center;
           display: flex;
           margin: 5px;
       }
       .sidebar div {
           background-color: #f0f0f0;
           padding: 20px;
           width: 200px;
       }
       .sidebar a {
           display: inline-block;
	        padding: 10px 20px;
	        margin-bottom: 10px;
	        border: 1px solid transparent;
	        border-radius: 4px;
	        text-align: center;
	        text-decoration: none;
	        color: #fff; /* 텍스트 색상 */
	        cursor: pointer;
       }
       
       #leftBar {
       		margin-right: 5%;
       }
       
       #rightBar {
       		margin-left: 5%;
       }
       .slider-container {
	        display: flex;
	        align-items: center;
	        justify-content: center; /* 슬라이더를 중앙으로 정렬 */
	        width: 100%;
	    }
       .slider {
	        width: 45%;
	        height: 400px;
	        overflow: hidden;
	        position: relative;
	    }
	    .slides {
	        display: flex;
	        width: calc(100% * 10); /* 슬라이드 수에 따라 조정 */
	        animation: slide 50s linear infinite; /* 애니메이션 설정 */
	    }
	    .slides img {
	        width: 7%; /* 슬라이드 수에 따라 조정 */
        	height: 100%; /* 컨테이너의 높이를 100%로 설정 */
	        object-fit: cover;
	    }
	    
	    @keyframes slide {
	        0% { transform: translateX(0); }
	        100% { transform: translateX(-100%); }
	        
	    }
	    
	    .btn-primary {
	        background-color: #007bff;
	        border-color: #007bff;
	    }
	    .btn-primary:hover {
	        background-color: #0056b3;
	        border-color: #004085;
	    }
	    .btn-secondary {
	        background-color: #6c757d;
	        border-color: #6c757d;
	    }
	    .btn-secondary:hover {
	        background-color: #5a6268;
	        border-color: #545b62;
	    }
	    .btn-success {
	        background-color: #28a745;
	        border-color: #28a745;
	    }
	    .btn-success:hover {
	        background-color: #218838;
	        border-color: #1e7e34;
	    }
	    .btn-info {
	        background-color: #17a2b8;
	        border-color: #17a2b8;
	    }
	    .btn-info:hover {
	        background-color: #138496;
	        border-color: #117a8b;
	    }
	    .btn-warning {
	        background-color: #ffc107;
	        border-color: #ffc107;
	    }
	    .btn-warning:hover {
	        background-color: #e0a800;
	        border-color: #d39e00;
	    }
    
	</style>
	
	<script>
		const slides = document.querySelector('.slides');
	    let clone = slides.cloneNode(true);
	    slides.parentNode.appendChild(clone);
	
	    function resetAnimation() {
	        slides.style.animation = 'none';
	        slides.offsetHeight; 
	        slides.style.animation = null;
	    }

    	slides.addEventListener('animationiteration', resetAnimation);
	</script>
	
</head>
<body>
    <jsp:include page="header.jsp"/>
    
    <div class="main-content">
        <h1>가장 좋아하는 문화를 골라보세요!</h1>
        <p>한중일 3개국의 문화를 비교하고, 내가 보기에 가장 좋은 문화를 선택하세요!</p>
        <div class="slider-container">
	        <div class="slider">
			    <div class="slides">
			        <img src="images/Korea/Clothes/도포.png" alt="Image 1">
			        <img src="images/Japan/Clothes/유카타.png" alt="Image 2">
			        <img src="images/China/Clothes/qipao.png" alt="Image 3">
			        <img src="images/Korea/Clothes/두루마기.png" alt="Image 4">
			        <img src="images/Japan/Clothes/기모노.png" alt="Image 5">
			        <img src="images/Korea/food/떡볶이.png" alt="Image 6">
			        <img src="images/Japan/food/텐푸라.png" alt="Image 7">
			        <img src="images/China/food/북경오리.png" alt="Image 8">
			        <img src="images/Korea/food/한정식.png" alt="Image 9">
			        
			        <img src="images/Korea/Clothes/도포.png" alt="Image 1">
			        <img src="images/Japan/Clothes/유카타.png" alt="Image 2">
			        <img src="images/China/Clothes/qipao.png" alt="Image 3">
			        <img src="images/Korea/Clothes/두루마기.png" alt="Image 4">
			        <img src="images/Japan/Clothes/기모노.png" alt="Image 5">
			        <img src="images/Korea/food/떡볶이.png" alt="Image 6">
			        <img src="images/Japan/food/텐푸라.png" alt="Image 7">
			        <img src="images/China/food/북경오리.png" alt="Image 8">
			        <img src="images/Korea/food/한정식.png" alt="Image 9">
			    </div>
			</div>
        </div>
        
        <div class="sidebar">
            <div id="leftBar">
                <h4>등수 매기기</h4>
                <a href="vote.jsp?category=clothes" class="btn-primary">의복</a>
        		<a href="vote.jsp?category=food" class="btn-secondary">음식</a>
            </div>
            
            <div id="rightBar">
                <h4>역대 통계 보기</h4>
		        <a href="totalRankings.jsp?category=clothes" class="btn-info">의복 통계 보기</a>
		        <a href="totalRankings.jsp?category=food" class="btn-warning">음식 통계 보기</a>
            </div>
        </div>
        
    </div>
    
    <jsp:include page="footer.jsp"/>
</body>
</html>