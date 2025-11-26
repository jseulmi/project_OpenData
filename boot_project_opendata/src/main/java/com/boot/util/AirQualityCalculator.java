package com.boot.util;

import com.boot.dto.AirQualityDTO;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class AirQualityCalculator {

    /**
     * 시도별 평균 계산
     */
    public Map<String, AirQualityDTO> calculateSidoAverages(List<AirQualityDTO> list) {

        Map<String, List<AirQualityDTO>> grouped = new HashMap<>();

        for (AirQualityDTO s : list) {
            String sido = s.getSidoName();
            if (sido == null || sido.isBlank()) continue;

            grouped.computeIfAbsent(sido, k -> new ArrayList<>()).add(s);
        }

        // 시도 순서
        List<String> sidoOrder = Arrays.asList(
                "서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종",
                "경기", "강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주"
        );

        Map<String, AirQualityDTO> result = new LinkedHashMap<>();

        for (String sido : sidoOrder) {
            List<AirQualityDTO> rows = grouped.get(sido);
            if (rows == null || rows.isEmpty()) continue;

            double avgPm10 = rows.stream().mapToInt(AirQualityDTO::getPm10Value).average().orElse(0);
            double avgPm25 = rows.stream().mapToInt(AirQualityDTO::getPm25Value).average().orElse(0);
            double avgO3 = rows.stream().mapToDouble(AirQualityDTO::getO3Value).average().orElse(0);
            double avgNo2 = rows.stream().mapToDouble(AirQualityDTO::getNo2Value).average().orElse(0);
            double avgCo = rows.stream().mapToDouble(AirQualityDTO::getCoValue).average().orElse(0);
            double avgSo2 = rows.stream().mapToDouble(AirQualityDTO::getSo2Value).average().orElse(0);

            // CAI 등급
            int cai = Math.max(
                    Math.max(gradePm10(avgPm10), gradePm25(avgPm25)),
                    Math.max(Math.max(gradeO3(avgO3), gradeNo2(avgNo2)),
                             Math.max(gradeCo(avgCo), gradeSo2(avgSo2)))
            );

            String gradeText = getGradeText(cai);

            AirQualityDTO dto = new AirQualityDTO();
            dto.setSidoName(sido);
            dto.setStationName(sido);

            dto.setPm10Value((int) avgPm10);
            dto.setPm25Value((int) avgPm25);
            dto.setO3Value(avgO3);
            dto.setNo2Value(avgNo2);
            dto.setCoValue(avgCo);
            dto.setSo2Value(avgSo2);

            dto.setKhaiGrade(cai);
            dto.setKhaiValue(cai);
            dto.setDataTime(gradeText);

            result.put(sido, dto);
        }

        return result;
    }

    private int gradePm10(double v) {
        if (v <= 30) return 50;
        if (v <= 80) return 100;
        if (v <= 150) return 250;
        return 500;
    }

    private int gradePm25(double v) {
        if (v <= 15) return 50;
        if (v <= 35) return 100;
        if (v <= 75) return 250;
        return 500;
    }

    private int gradeO3(double v) {
        if (v <= 0.03) return 50;
        if (v <= 0.09) return 100;
        if (v <= 0.15) return 250;
        return 500;
    }

    private int gradeNo2(double v) {
        if (v <= 0.03) return 50;
        if (v <= 0.06) return 100;
        if (v <= 0.20) return 250;
        return 500;
    }

    private int gradeCo(double v) {
        if (v <= 2.0) return 50;
        if (v <= 9.0) return 100;
        if (v <= 15.0) return 250;
        return 500;
    }

    private int gradeSo2(double v) {
        if (v <= 0.02) return 50;
        if (v <= 0.05) return 100;
        if (v <= 0.15) return 250;
        return 500;
    }

    private String getGradeText(int cai) {
        if (cai <= 50) return "좋음";
        if (cai <= 100) return "보통";
        if (cai <= 250) return "나쁨";
        return "매우나쁨";
    }
}
