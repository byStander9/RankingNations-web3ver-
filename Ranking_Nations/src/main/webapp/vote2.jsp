<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, com.ranking.model.DatabaseManager, com.google.gson.Gson" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Outdoor Gear Rating</title>
<style>
    html, body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
        height: 55%;
    }
    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 80%;
        padding: 7% 0 13% 0;
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
        height: 150%;
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
    .next-button {
        margin-top: 20px;
    }
    .selected {
        background-color: #000;
        color: #fff;
    }
    .next-button {
    	margin-left: 28%;
    }
</style>
<%@include file="dbconn.jsp" %>

<%
    String category = request.getParameter("category");
    List<String[]> ChinaData = new ArrayList<>();
    List<String[]> KoreaData = new ArrayList<>();
    List<String[]> JapanData = new ArrayList<>();
    try {
    	ChinaData = DatabaseManager.getData(category, "China");
        KoreaData = DatabaseManager.getData(category, "Korea");
        JapanData = DatabaseManager.getData(category, "Japan");
        
    } catch (Exception e) {
        e.printStackTrace();
    }
%>



<script>
	let category = '<%= request.getParameter("category") %>';
    let currentIndex = 0;
    const ChinaData = <%= new Gson().toJson(ChinaData) %>;
    const KoreaData = <%= new Gson().toJson(KoreaData) %>;
    const JapanData = <%= new Gson().toJson(JapanData) %>;
    let rankings = [];
    let currentRanks = [null, null, null];  // 현재 페이지의 등수 저장
    

    function renderImages() {
        const images = [ChinaData, KoreaData, JapanData];
        for (let i = 0; i < 3; i++) {
            if (currentIndex < images[i].length) {
                document.getElementById('gear-img-' + (i + 1)).src = images[i][currentIndex][1];
                document.getElementById('gear-text-' + (i + 1)).innerText = images[i][currentIndex][0];
                document.getElementById('description-' + (i + 1)).innerText = images[i][currentIndex][2];
                resetButtons(i + 1);  // 버튼 초기화
            } else {
                document.getElementById('gear-img-' + (i + 1)).src = '';
                document.getElementById('gear-text-' + (i + 1)).innerText = 'No more data';
                document.getElementById('description-' + (i + 1)).innerText = '';
            }
        }
    }

    function resetButtons(gearId) {
        for (let i = 1; i <= 3; i++) {
            document.getElementById('gear-' + gearId + '-rank-' + i).classList.remove('selected');
        }
        currentRanks[gearId - 1] = null;
    }

    function selectRank(gearId, rank) {
        // 동일한 기어에 대해 이미 선택된 등수가 있으면 초기화
        resetButtons(gearId);
        // 선택한 등수 버튼 강조
        document.getElementById('gear-' + gearId + '-rank-' + rank).classList.add('selected');
        currentRanks[gearId - 1] = rank;
    }

    function validateRanks() {
        const rankSet = new Set(currentRanks);
        if (rankSet.size !== currentRanks.length) {
            alert('Each rank must be unique per set of images.');
            return false;
        }
        return true;
    }

    function nextImages() {
        if (!validateRanks()) {
            return;
        }
        for (let i = 0; i < 3; i++) {
            rankings.push({ id: i, rank: currentRanks[i] });
        }
        currentIndex++;
        if (currentIndex >= ChinaData.length) {
            submitRankings();
        } else {
            renderImages();
        }
    }

    function submitRankings() {
    	
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'finalRanking.jsp';

        const input = document.createElement('input');
        input.name = 'category';
        input.value = category;
        form.appendChild(input);
        
        const input2 = document.createElement('input');
        input2.name = 'rankings';
        input2.value = JSON.stringify(rankings);
        form.appendChild(input2);

        document.body.appendChild(form);
        form.submit();
    }

    window.onload = function() {
        renderImages();
    }
    
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
    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="gear-item">
            <div id="gear-text-1">Outdoor Gear 1</div>
            <div class="image-frame" id="image-frame-1">
                <img id="gear-img-1" src="" alt="Outdoor Gear 1">
            </div>
            <div class="buttons" id="buttons-1">
                <button id="gear-1-rank-1" onclick="selectRank(1, 1)">1st</button>
                <button id="gear-1-rank-2" onclick="selectRank(1, 2)">2nd</button>
                <button id="gear-1-rank-3" onclick="selectRank(1, 3)">3rd</button>
            </div>
            <button onclick="toggleDescription(1)">Description</button>
		        <div id="description-1" class="description">
		            <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
		            
		        </div>
        </div>

        <div class="gear-item">
            <div id="gear-text-2">Outdoor Gear 2</div>
            <div class="image-frame" id="image-frame-2">
                <img id="gear-img-2" src="" alt="Outdoor Gear 2">
            </div>
            <div class="buttons" id="buttons-2">
                <button id="gear-2-rank-1" onclick="selectRank(2, 1)">1st</button>
                <button id="gear-2-rank-2" onclick="selectRank(2, 2)">2nd</button>
                <button id="gear-2-rank-3" onclick="selectRank(2, 3)">3rd</button>
            </div>
            <button onclick="toggleDescription(2)">Description</button>
		        <div id="description-2" class="description">
		            <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
		            
		        </div>
        </div>

        <div class="gear-item">
            <div id="gear-text-3">Outdoor Gear 3</div>
            <div class="image-frame" id="image-frame-3">
                <img id="gear-img-3" src="" alt="Outdoor Gear 3">
            </div>
            <div class="buttons" id="buttons-3">
                <button id="gear-3-rank-1" onclick="selectRank(3, 1)">1st</button>
                <button id="gear-3-rank-2" onclick="selectRank(3, 2)">2nd</button>
                <button id="gear-3-rank-3" onclick="selectRank(3, 3)">3rd</button>
            </div>
            <button onclick="toggleDescription(3)">Description</button>
		        <div id="description-3" class="description">
		            <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
		           
		        </div>
        </div>

    </div>
    <div class="next-button">
    	<button class="next-button" onclick="nextImages()">Next</button>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>


