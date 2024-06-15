package com.ranking.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.lang.reflect.Type;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class DatabaseManager {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/webserverdev_proj";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "rlsRms5244";

    public static List<String[]> getData(String category, String country) throws SQLException, ClassNotFoundException {
        List<String[]> data = new ArrayList<>();
        String query = "SELECT * FROM " + category + " WHERE country_name = '" + country + "'";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        stmt = conn.prepareStatement(query);
        
            try  {
            	rs = stmt.executeQuery();
                while (rs.next()) {
                    data.add(new String[]{rs.getString("clothing_name"), rs.getString("image"), rs.getString("description")});
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        
        return data;
    }
    
    public static void insertData(String category, String ranking) {
    	// JSON 문자열을 파싱하여 List<Map<String, Integer>>로 변환
        Gson gson = new Gson();
        Type listType = new TypeToken<List<Map<String, Integer>>>(){}.getType();
        List<Map<String, Integer>> rankings = gson.fromJson(ranking, listType);

        // 각 id 값에 따른 rank 값을 저장할 배열 리스트
        List<Integer> ranksChina = new ArrayList<>();
        List<Integer> ranksKorea = new ArrayList<>();
        List<Integer> ranksJapan = new ArrayList<>();

        // rankings 리스트를 순회하면서 각 id 값에 따른 rank 값을 배열에 추가
        for (Map<String, Integer> item : rankings) {
            int id = item.get("id");
            int rank = item.get("rank");

            switch (id) {
                case 0:
                    ranksChina.add(rank);
                    break;
                case 1:
                    ranksKorea.add(rank);
                    break;
                case 2:
                    ranksJapan.add(rank);
                    break;
            }
        }

        // 데이터베이스에 연결 및 데이터 삽입
        String url = "jdbc:mysql://localhost:3306/webserverdev_proj";
        String username = "root";
        String password = "rlsRms5244";
        Connection conn = null;
        PreparedStatement pstmtSelect = null;
        PreparedStatement pstmtUpdate = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);
            
            // 데이터를 각 국가에 대해 삽입
            updateData(conn, category, "China", ranksChina);
            updateData(conn, category, "Korea", ranksKorea);
            updateData(conn, category, "Japan", ranksJapan);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	if (pstmtSelect != null) try { pstmtSelect.close(); } catch (SQLException ignore) {}
            if (pstmtUpdate != null) try { pstmtUpdate.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }

    private static void updateData(Connection conn, String category, String country, List<Integer> ranks) throws SQLException {
    	String selectSQL = "SELECT firstPlace, secondPlace, thirdPlace, totalScore FROM scoreBoard WHERE category = ? AND country_name = ?";
        String updateSQL = "UPDATE scoreBoard SET firstPlace = ?, secondPlace = ?, thirdPlace = ?, totalScore = ? WHERE category = ? AND country_name = ?";

        PreparedStatement pstmtSelect = conn.prepareStatement(selectSQL);
        pstmtSelect.setString(1, category);
        pstmtSelect.setString(2, country);
        ResultSet rs = pstmtSelect.executeQuery();

        int firstPlaceCount = 0;
        int secondPlaceCount = 0;
        int thirdPlaceCount = 0;

        // 각 리스트의 rank 값을 순회하며 1등, 2등, 3등의 개수를 셉니다.
        for (int rank : ranks) {
            if (rank == 1) firstPlaceCount++;
            if (rank == 2) secondPlaceCount++;
            if (rank == 3) thirdPlaceCount++;
        }
        
        if (rs.next()) {
            // 기존 값들을 가져옵니다.
            firstPlaceCount += rs.getInt("firstPlace");
            secondPlaceCount += rs.getInt("secondPlace");
            thirdPlaceCount += rs.getInt("thirdPlace");
            int totalScore = firstPlaceCount * 3 + secondPlaceCount * 2 + thirdPlaceCount * 1;
            totalScore += rs.getInt("totalScore");

            PreparedStatement pstmtUpdate = conn.prepareStatement(updateSQL);
            pstmtUpdate.setInt(1, firstPlaceCount);
            pstmtUpdate.setInt(2, secondPlaceCount);
            pstmtUpdate.setInt(3, thirdPlaceCount);
            pstmtUpdate.setInt(4, totalScore);
            pstmtUpdate.setString(5, category);
            pstmtUpdate.setString(6, country);
            pstmtUpdate.executeUpdate();
        }
        rs.close();
        pstmtSelect.close();
    
    }
    
}
