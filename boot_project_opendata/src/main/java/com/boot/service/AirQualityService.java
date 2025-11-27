package com.boot.service;

import com.boot.dto.AirQualityDTO;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AirQualityService {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final KakaoLocalService kakaoLocalService;
    private final RedisCacheService redisCacheService;

    private static final String REDIS_KEY = "AIR:ALL_DATA";

    private static final String SERVICE_KEY =
            "a682a33e4881f5f1255dfa8b00d2fd6096c874effa3269244204a5e03f2d607b";

    private static final List<String> SIDO_LIST = List.of(
            "서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종",
            "경기", "강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주"
    );

    /**
     * ====================================
     * ① 전국 대기질 조회 (Redis 우선)
     * ====================================
     */
    public List<AirQualityDTO> getAllAirQuality() {
        try {
            // 1) Redis 캐싱 우선
            String cachedJson = redisCacheService.get(REDIS_KEY);
            if (cachedJson != null) {
                return objectMapper.readValue(
                        cachedJson,
                        new TypeReference<List<AirQualityDTO>>() {}
                );
            }

            // 2) 병렬로 전체 시도 API 호출
            List<AirQualityDTO> result =
                    SIDO_LIST.stream()   // ★ parallelStream → stream() 로 변경
                            .map(this::getAirQualityBySido)
                            .filter(list -> list != null && !list.isEmpty())
                            .flatMap(List::stream)
                            .toList();

            // 3) Redis 저장
            String json = objectMapper.writeValueAsString(result);
            redisCacheService.set(REDIS_KEY, json, 3600);

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * ====================================
     * ② 특정 시도의 대기질 조회 (API 호출)
     * ====================================
     */
    public List<AirQualityDTO> getAirQualityBySido(String sidoName) {
        try {
            URI uri = UriComponentsBuilder
                    .fromUriString("https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty")
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("sidoName", sidoName)
                    .queryParam("returnType", "json")
                    .queryParam("numOfRows", "1000")
                    .queryParam("pageNo", "1")
                    .queryParam("ver", "1.4")
                    .encode(StandardCharsets.UTF_8)
                    .build()
                    .toUri();

            String json = restTemplate.getForObject(uri, String.class);
            return parseAirQualityJson(json);

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * ====================================
     * ③ JSON → DTO 변환
     * ====================================
     */
    private List<AirQualityDTO> parseAirQualityJson(String json) throws Exception {

        JsonNode root = objectMapper.readTree(json);
        JsonNode items = root.path("response").path("body").path("items");

        if (!items.isArray()) return new ArrayList<>();

        List<AirQualityDTO> list = new ArrayList<>();

        // ★ 순차 처리
        for (JsonNode item : items) {

            String sidoName = item.path("sidoName").asText("");
            String stationName = item.path("stationName").asText("");
            String dataTime = item.path("dataTime").asText("");

            Integer pm10Value = parseInteger(item.path("pm10Value").asText());
            Integer pm25Value = parseInteger(item.path("pm25Value").asText());
            Double o3Value = parseDouble(item.path("o3Value").asText());
            Double no2Value = parseDouble(item.path("no2Value").asText());
            Double so2Value = parseDouble(item.path("so2Value").asText());
            Double coValue = parseDouble(item.path("coValue").asText());

            Integer pm10Grade = parseInteger(item.path("pm10Grade").asText());
            Integer pm25Grade = parseInteger(item.path("pm25Grade").asText());
            Integer khaiValue = parseInteger(item.path("khaiValue").asText());
            Integer khaiGrade = parseInteger(item.path("khaiGrade").asText());
            
            int calcO3 = gradeO3(o3Value != null ? o3Value : 0.0);
            int calcNO2 = gradeNO2(no2Value != null ? no2Value : 0.0);
            // ★ 카카오 API 순차 호출 (중요)
            double[] location = kakaoLocalService.getLocation(sidoName, stationName);

            list.add(new AirQualityDTO(
                    sidoName,
                    stationName,
                    dataTime,
                    pm10Value != null ? pm10Value : 0,
                    pm25Value != null ? pm25Value : 0,
                    o3Value != null ? o3Value : 0.0,
                    no2Value != null ? no2Value : 0.0,
                    so2Value != null ? so2Value : 0.0,
                    coValue != null ? coValue : 0.0,
                    pm10Grade != null ? pm10Grade : 0,
                    pm25Grade != null ? pm25Grade : 0,
                    calcO3, 
                    calcNO2, 
                    khaiValue != null ? khaiValue : 0,
                    khaiGrade != null ? khaiGrade : 0,
                    location[0],
                    location[1]
            ));
        }

        return list;
    }
    
    public AirQualityDTO getStationDetailData(String stationName) {
        
        List<AirQualityDTO> allData = getAllAirQuality(); // Redis 또는 API에서 전체 데이터 로드
        
        return allData.stream()
                .filter(data -> data.getStationName().equals(stationName))
                .findFirst()
                .orElse(null); // 해당 측정소 데이터가 없으면 null 반환
    }

    private Integer parseInteger(String text) {
        try {
            if (text == null || text.isBlank() || "-".equals(text)) return null;
            return Integer.parseInt(text);
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDouble(String text) {
        try {
            if (text == null || text.isBlank() || "-".equals(text)) return null;
            return Double.parseDouble(text);
        } catch (Exception e) {
            return null;
        }
    }
    private int gradeO3(double v) {
        if (v <= 0.030) return 1;
        if (v <= 0.090) return 2;
        if (v <= 0.150) return 3;
        return 4;
    }

    private int gradeNO2(double v) {
        if (v <= 0.030) return 1;
        if (v <= 0.060) return 2;
        if (v <= 0.200) return 3;
        return 4;
    }
    
    
}


