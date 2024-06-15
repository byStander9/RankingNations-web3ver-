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
        height: 40vh;
    }
    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 80%;
        padding: 3% 0 17% 0;
    }
    .gear-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 30%;
        height: 37vh;
        text-align: center;
        margin: 4% 0 0 0 ;
    }
    .buttons {
        margin-top: 10px;
    }
    .description-container {
        display: none;
        flex-direction: column;
        align-items: center;
        margin-top: 20px;
    }
    .description-content {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }
    .description-content img {
        width: 100px; /* 작은 이미지 사이즈 */
        height: auto;
        margin-right: 20px;
    }
    .description-text {
        flex: 1;
    }
    .description {
        padding-bottom: 2vh;
    }
    .image-frame {
        width: 100%;
        height: 150vh;
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
        margin: 3px 0 15px 28%
    }
    .selected {
        background-color: #000;
        color: #fff;
    }
    .prompt-container {
        align-items: center;
        width: 100%;
    }
    .prompt-input {
        width: 90%;
        padding: 10px;
        font-size: 16px;
        margin-bottom: 20px;
    }
    .prompt-response {
        width: 90%;
        padding: 10px;
        border: 1px solid #ccc;
        background-color: #f9f9f9;
        margin-left: 6px;
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
        for (let i = 1; i < 4; i++) {
    		var description = document.getElementById('description-container-' + i);
    		if(!(description.style.display === 'none' || description.style.display === '')) {
    			toggleDescription(i);
    		}
    	}
        
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
            alert('1,2,3등이 각각 하나씩 지정되어야 합니다!');
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
    	console.log('toggle!');
        var text = document.getElementById('gear-text-' + gearId);
        var imgFrame = document.getElementById('image-frame-' + gearId);
        var buttons = document.getElementById('buttons-' + gearId);
        var description = document.getElementById('description-container-' + gearId);
        var newImg = document.getElementById('smallImage-' + gearId);
        var gearImg = document.getElementById('gear-img-' + gearId);
        
        if (description.style.display === 'none' || description.style.display === '') {
        	console.log('executed');
            text.style.display = 'none';
            imgFrame.style.display = 'none';
            buttons.style.display = 'none';
            newImg.src = gearImg.src; // 작은 이미지의 소스 설정
            description.style.display = 'flex';
        } else {
        	console.log('executed2');
        	console.log(description.style.display);
            text.style.display = 'block';
            imgFrame.style.display = 'flex';
            buttons.style.display = 'block';
            description.style.display = 'none';
        }
    }
    
    async function getChatGPTResponse(prompt) {
        
        const url = 'https://api.openai.com/v1/chat/completions';
        const data = {
            model: "gpt-3.5-turbo",
            messages: [{"role": "user", "content": prompt}],
            temperature: 1,
            top_p: 1,
            n: 1,
            stream: false,
            max_tokens: 500,
            presence_penalty: 0,
            frequency_penalty: 0
        };

        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${apiKey}`
            },
            body: JSON.stringify(data)
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Error from API: ${errorText}`);
        }
        
        const result = await response.json();
		
        return result.choices[0].message.content;
    }

    async function handlePromptInput(event, gearId) {
        if (event.key === 'Enter') {
            event.preventDefault();
            const promptInput = document.getElementById('prompt-input-' + gearId);
            const promptResponse = document.getElementById('prompt-response-' + gearId);
            const userPrompt = promptInput.value;
            
            if (userPrompt !== "") {
            	console.log('userPrompt: ' + userPrompt);
                promptResponse.innerHTML = "Loading...";
                const response = await getChatGPTResponse(userPrompt);
                promptResponse.innerHTML = response;
            }
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
                <button id="gear-1-rank-1" onclick="selectRank(1, 1)">1등</button>
                <button id="gear-1-rank-2" onclick="selectRank(1, 2)">2등</button>
                <button id="gear-1-rank-3" onclick="selectRank(1, 3)">3등</button>
            </div>
            <button onclick="toggleDescription(1)">문화 설명</button>
            <div id="description-container-1" class="description-container">
                <div class="description-content">
                    <img id="smallImage-1" alt="gear-smallimg-1">
                    <div id="description-1" class="description">
                        <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
                        This is the description text.
                    </div>
                </div>
                <div id="prompt-container-1" class="prompt-container">
                    <input id="prompt-input-1" class="prompt-input" type="text" placeholder="추가 질문사항을 입력하고 ENTER!" onkeypress="handlePromptInput(event, 1)">
                    <div id="prompt-response-1" class="prompt-response"></div>
                </div>
            </div>
        </div>

        <div class="gear-item">
            <div id="gear-text-2">Outdoor Gear 1</div>
            <div class="image-frame" id="image-frame-2">
                <img id="gear-img-2" src="" alt="Outdoor Gear 2">
            </div>
            <div class="buttons" id="buttons-2">
                <button id="gear-2-rank-1" onclick="selectRank(2, 1)">1등</button>
                <button id="gear-2-rank-2" onclick="selectRank(2, 2)">2등</button>
                <button id="gear-2-rank-3" onclick="selectRank(2, 3)">3등</button>
            </div>
            <button onclick="toggleDescription(2)">문화 설명</button>
            <div id="description-container-2" class="description-container">
                <div class="description-content">
                    <img id="smallImage-2" alt="gear-smallimg-2">
                    <div id="description-2" class="description">
                        <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
                        This is the description text.
                    </div>
                </div>
                <div id="prompt-container-2" class="prompt-container">
                    <input id="prompt-input-2" class="prompt-input" type="text" placeholder="추가 질문사항을 입력하고 ENTER!" onkeypress="handlePromptInput(event, 2)">
                    <div id="prompt-response-2" class="prompt-response"></div>
                </div>
            </div>
        </div>

        <div class="gear-item">
            <div id="gear-text-3">Outdoor Gear 1</div>
            <div class="image-frame" id="image-frame-3">
                <img id="gear-img-3" src="" alt="Outdoor Gear 3">
            </div>
            <div class="buttons" id="buttons-3">
                <button id="gear-3-rank-1" onclick="selectRank(3, 1)">1등</button>
                <button id="gear-3-rank-2" onclick="selectRank(3, 2)">2등</button>
                <button id="gear-3-rank-3" onclick="selectRank(3, 3)">3등</button>
            </div>
            <button onclick="toggleDescription(3)">문화 설명</button>
            <div id="description-container-3" class="description-container">
                <div class="description-content">
                    <img id="smallImage-3" alt="gear-smallimg-3">
                    <div id="description-3" class="description">
                        <%-- 데이터베이스에서 가져온 설명서 형식의 내용 출력 --%>
                        This is the description text.
                    </div>
                </div>
                <div id="prompt-container-3" class="prompt-container">
                    <input id="prompt-input-3" class="prompt-input" type="text" placeholder="추가 질문사항을 입력하고 ENTER!" onkeypress="handlePromptInput(event, 3)">
                    <div id="prompt-response-3" class="prompt-response"></div>
                </div>
            </div>
        </div>

    </div>
    <div class="next-button">
    	<button class="next-button" onclick="nextImages()" id="next-button">다음</button>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>


