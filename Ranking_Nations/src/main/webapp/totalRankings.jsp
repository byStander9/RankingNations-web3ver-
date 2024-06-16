<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.google.gson.Gson, com.google.gson.reflect.TypeToken, com.ranking.model.DatabaseManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Total Rankings</title>
<style>
    html, body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
        height: 55%;
    }
    body {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .container {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        width: 100%;
        padding: 0;
    }
    header {
        margin-bottom: 5px;
    }
    table {
        width: 70%;
        border-collapse: collapse;
        margin: 5px 0;
    }
    th, td {
        border: 1px solid #000;
        padding: 4px;
        text-align: center;
    }
    th {
        background-color: #333;
        color: #fff;
    }
    td {
        background-color: #f9f9f9;
    }
    .options {
        margin: 5px 0;
    }
    footer {
        width: 100%;
        text-align: center;
        padding: 10px 0;
        background-color: #333;
        color: #fff;
        position: fixed;
        bottom: 0;
    }
    
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <h1>Total Rankings</h1>
        <table>
            <thead>
                <tr>
                    <th>국가</th>
                    <th>1등 횟수 (3 점)</th>
                    <th>2등 횟수 (2 점)</th>
                    <th>3등 횟수 (1 점)</th>
                    <th>종합 점수</th>
                </tr>
            </thead>
            <tbody>
                <%
                String category = request.getParameter("category");
                Map<String, int[]> rankings = DatabaseManager.getCategoryRankings(category);

                int[] chinaScores = rankings.getOrDefault("China", new int[4]);
                int[] koreaScores = rankings.getOrDefault("Korea", new int[4]);
                int[] japanScores = rankings.getOrDefault("Japan", new int[4]);

                out.print("<tr><td>China</td><td>" + chinaScores[0] + "</td><td>" + chinaScores[1] + "</td><td>" + chinaScores[2] + "</td><td>" + chinaScores[3] + "</td></tr>");
                out.print("<tr><td>Korea</td><td>" + koreaScores[0] + "</td><td>" + koreaScores[1] + "</td><td>" + koreaScores[2] + "</td><td>" + koreaScores[3] + "</td></tr>");
                out.print("<tr><td>Japan</td><td>" + japanScores[0] + "</td><td>" + japanScores[1] + "</td><td>" + japanScores[2] + "</td><td>" + japanScores[3] + "</td></tr>");
                %>
            </tbody>
        </table>
        <div class="options">
            <label><input type="checkbox" id="showTotalScore" onclick="updateChart()" checked> 종합 점수 보기</label>
            <label><input type="checkbox" id="show1stPlace" onclick="updateChart()" checked> 1등 횟수 보기</label>
            <label><input type="checkbox" id="show2ndPlace" onclick="updateChart()" checked> 2등 횟수 보기</label>
            <label><input type="checkbox" id="show3rdPlace" onclick="updateChart()" checked> 3등 횟수 보기</label>
        </div>
        <canvas id="rankingChart" width="200" height="55"></canvas>
    </div>

    <jsp:include page="footer.jsp" />
</body>
<script>
    const chinaScores = [<%= chinaScores[0] %>, <%= chinaScores[1] %>, <%= chinaScores[2] %>, <%= chinaScores[3] %>];
    const koreaScores = [<%= koreaScores[0] %>, <%= koreaScores[1] %>, <%= koreaScores[2] %>, <%= koreaScores[3] %>];
    const japanScores = [<%= japanScores[0] %>, <%= japanScores[1] %>, <%= japanScores[2] %>, <%= japanScores[3] %>];

    const data = {
        labels: ['China', 'Korea', 'Japan'],
        datasets: [
            {
                label: '1등 횟수',
                data: [chinaScores[0], koreaScores[0], japanScores[0]],
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            },
            {
                label: '2등 횟수',
                data: [chinaScores[1], koreaScores[1], japanScores[1]],
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            },
            {
                label: '3등 횟수',
                data: [chinaScores[2], koreaScores[2], japanScores[2]],
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            },
            {
                label: '종합 점수',
                data: [chinaScores[3], koreaScores[3], japanScores[3]],
                backgroundColor: 'rgba(153, 102, 255, 0.2)',
                borderColor: 'rgba(153, 102, 255, 1)',
                borderWidth: 1
            }
        ]
    };

    const config = {
        type: 'bar',
        data: data,
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    };

    const rankingChart = new Chart(
        document.getElementById('rankingChart'),
        config
    );

    function updateChart() {
        const showTotalScore = document.getElementById('showTotalScore').checked;
        const show1stPlace = document.getElementById('show1stPlace').checked;
        const show2ndPlace = document.getElementById('show2ndPlace').checked;
        const show3rdPlace = document.getElementById('show3rdPlace').checked;

        rankingChart.data.datasets[0].hidden = !show1stPlace;
        rankingChart.data.datasets[1].hidden = !show2ndPlace;
        rankingChart.data.datasets[2].hidden = !show3rdPlace;
        rankingChart.data.datasets[3].hidden = !showTotalScore;

        rankingChart.update();
    }
</script>
</html>
