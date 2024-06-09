<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Outdoor Gear</title>
<style>
	html, body {
		font-family: Arial, sans-serif;
		margin: 0;
		padding: 0;
		background-color: #f5f5f5;
		height: 60%;
	}
	.container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 80%;
        padding: 10% 0;
    }
    .gear-item {
        display: inline-block;
        width: 30%;
        height: 100%;
        text-align: center;
        margin: 0 1%;
    }
    .buttons {
        margin-top: 10px;
    }
    .description {
        display: none;
    }
    
    .image-frame {
        width: 100%;
        height: 70%; /* 부모 요소 높이의 30%로 설정 */
        border: 1px solid #ccc;
        justify-content: center;
        align-items: center;
        display: flex;
        overflow: hidden;
        position: relative;
    }
    .image-frame img {
        max-width: 100%;
        max-height: 100%;
        position: absolute;
        object-fit: cover;
    }
</style>
<script>
	function toggleDescription(gearId) {
	    var text = document.getElementById('gear-text-' + gearId);
	    var img = document.getElementById('image-frame-' + gearId);
	    var buttons = document.getElementById('buttons-' + gearId);
	    var description = document.getElementById('description-' + gearId);
	
	    if (description.style.display === 'none') {
	        text.style.display = 'none';
	        img.style.display = 'none';
	        buttons.style.display = 'none';
	        description.style.display = 'block';
	    } else {
	        text.style.display = 'block';
	        img.style.display = 'block';
	        buttons.style.display = 'block';
	        description.style.display = 'none';
	    }
	}
</script>
</head>
<body>
	<%@include file="dbconn.jsp" %>
	
	<%
		String category = request.getParameter("category");
		String[][] ChinaData = new String[5][3];
		String[][] KoreaData = new String[5][3];
		String[][] JapanData = new String[5][3];
		try {
	        String sql = "SELECT * FROM " +category+ " WHERE country_name = 'China'"; // 3개의 이미지만 가져오기
	        rs = stmt.executeQuery(sql);
	        int index1 = 0;
	        while(rs.next()) {
	            ChinaData[index1][0] = rs.getString("clothing_name");
	            ChinaData[index1][1] = rs.getString("image");
	            ChinaData[index1][2] = rs.getString("description");
	            index1++;
	        }
	        
	        sql = "SELECT * FROM " +category+ " WHERE country_name = 'Korea'"; // 3개의 이미지만 가져오기
	        rs = stmt.executeQuery(sql);
	        index1 = 0;
	        while(rs.next()) {
	            KoreaData[index1][0] = rs.getString("clothing_name");
	            KoreaData[index1][1] = rs.getString("image");
	            KoreaData[index1][2] = rs.getString("description");
	            index1++;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (rs != null) rs.close();
	        if (stmt != null) stmt.close();
	        if (conn != null) conn.close();
	    }
	%>
    <jsp:include page="header.jsp"/>
    
    <div class="container">
    	<div class="gear-item">
		    <div id="gear-text-1">Outdoor Gear 1</div>
		   	<div class="image-frame" id="image-frame-1">
		        <img id="gear-img-1" src="<%= ChinaData[0][1] %>" alt="Outdoor Gear 1">
		    </div>
	        <div id="buttons-1" class="buttons">
	            <button>1st</button>
	            <button>2nd</button>
	            <button>3rd</button>
	        </div>
	        <button onclick="toggleDescription(1)">Description</button>
	        <div id="description-1" class="description">
	            <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
	            <%
	                out.print(ChinaData[0][2]);
	            %>
	        </div>
	    </div>
	    
	    <div class="gear-item">
	        <div id="gear-text-2">Outdoor Gear 2</div>
	        <div class="image-frame" id="image-frame-2">
		        <img id="gear-img-2" src="<%= KoreaData[0][1] %>" alt="Outdoor Gear 2">
		    </div>
	        <div id="buttons-2" class="buttons">
	            <button>1st</button>
	            <button>2nd</button>
	            <button>3rd</button>
	        </div>
	        <button onclick="toggleDescription(2)">Description</button>
	        <div id="description-2" class="description">
	            <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
	            <%
	                
	            %>
	        </div>
	    </div>
	    
	    <div class="gear-item">
	        <div id="gear-text-3">Outdoor Gear 3</div>
	        <div class="image-frame" id="image-frame-3">
		        <img id="gear-img-3" src="<%= ChinaData[2][1] %>" alt="Outdoor Gear 3">
		    </div>
	        <div id="buttons-3" class="buttons">
	            <button>1st</button>
	            <button>2nd</button>
	            <button>3rd</button>
	        </div>
	        <button onclick="toggleDescription(3)">Description</button>
	        <div id="description-3" class="description">
	            <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
	            <%
	            	
	            %>
	        </div>
	    </div>
    </div>
    
    
    
    <jsp:include page="footer.jsp"/>
    
</body>
</html>
