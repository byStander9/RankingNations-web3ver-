<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.google.gson.Gson, com.google.gson.reflect.TypeToken" %>
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
        height: 100%;
    }
    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        width: 100%;
        height: 100%;
        padding: 2%;
    }
    table {
        width: 70%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    th, td {
        border: 1px solid #000;
        padding: 8px;
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
        margin: 20px 0;
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
                    <th>Country</th>
                    <th>1st Place (3 points)</th>
                    <th>2nd Place (2 points)</th>
                    <th>3rd Place (1 point)</th>
                    <th>Total Score</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String category = request.getParameter("category");
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    int[] chinaScores = {0, 0, 0};
                    int[] koreaScores = {0, 0, 0};
                    int[] japanScores = {0, 0, 0};
                    int chinaTotal = 0;
                    int koreaTotal = 0;
                    int japanTotal = 0;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/webserverdev_proj", "root", "rlsRms5244");

                        String sql = "SELECT country_name, firstPlace, secondPlace, thirdPlace, totalScore FROM scoreBoard WHERE category = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, category);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            String country = rs.getString("country_name");
                            int firstPlace = rs.getInt("firstPlace");
                            int secondPlace = rs.getInt("secondPlace");
                            int thirdPlace = rs.getInt("thirdPlace");
                            int totalScore = rs.getInt("totalScore");

                            if ("China".equalsIgnoreCase(country)) {
                                chinaScores[0] += firstPlace;
                                chinaScores[1] += secondPlace;
                                chinaScores[2] += thirdPlace;
                                chinaTotal += totalScore;
                            } else if ("Korea".equalsIgnoreCase(country)) {
                                koreaScores[0] += firstPlace;
                                koreaScores[1] += secondPlace;
                                koreaScores[2] += thirdPlace;
                                koreaTotal += totalScore;
                            } else if ("Japan".equalsIgnoreCase(country)) {
                                japanScores[0] += firstPlace;
                                japanScores[1] += secondPlace;
                                japanScores[2] += thirdPlace;
                                japanTotal += totalScore;
                            }
                        }

                        out.print("<tr><td>China</td><td>" + chinaScores[0] + "</td><td>" + chinaScores[1] + "</td><td>" + chinaScores[2] + "</td><td>" + chinaTotal + "</td></tr>");
                        out.print("<tr><td>Korea</td><td>" + koreaScores[0] + "</td><td>" + koreaScores[1] + "</td><td>" + koreaScores[2] + "</td><td>" + koreaTotal + "</td></tr>");
                        out.print("<tr><td>Japan</td><td>" + japanScores[0] + "</td><td>" + japanScores[1] + "</td><td>" + japanScores[2] + "</td><td>" + japanTotal + "</td></tr>");

                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                    }
                %>
            </tbody>
        </table>
        <div class="options">
            <label><input type="checkbox" id="showTotalScore" onclick="updateChart()" checked> Show Total Score</label>
            <label><input type="checkbox" id="show1stPlace" onclick="updateChart()" checked> Show 1st Place</label>
            <label><input type="checkbox" id="show2ndPlace" onclick="updateChart()" checked> Show 2nd Place</label>
            <label><input type="checkbox" id="show3rdPlace" onclick="updateChart()" checked> Show 3rd Place</label>
        </div>
        <canvas id="rankingChart" width="400" height="200"></canvas>
    </div>

    <jsp:include page="footer.jsp" />
</body>
<script>
    const chinaScores = [<%= chinaScores[0] %>, <%= chinaScores[1] %>, <%= chinaScores[2] %>, <%= chinaTotal %>];
    const koreaScores = [<%= koreaScores[0] %>, <%= koreaScores[1] %>, <%= koreaScores[2] %>, <%= koreaTotal %>];
    const japanScores = [<%= japanScores[0] %>, <%= japanScores[1] %>, <%= japanScores[2] %>, <%= japanTotal %>];

    const data = {
        labels: ['China', 'Korea', 'Japan'],
        datasets: [
            {
                label: '1st Place',
                data: [chinaScores[0], koreaScores[0], japanScores[0]],
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            },
            {
                label: '2nd Place',
                data: [chinaScores[1], koreaScores[1], japanScores[1]],
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            },
            {
                label: '3rd Place',
                data: [chinaScores[2], koreaScores[2], japanScores[2]],
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            },
            {
                label: 'Total Score',
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
