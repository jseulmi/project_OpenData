package com.boot.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.nio.charset.StandardCharsets;

@Service
@RequiredArgsConstructor
public class KakaoLocalService {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RedisCacheService redisCacheService;  // ★ 추가

    private static final String KAKAO_API_KEY = "a7dbe8639d860d6cc00ef0b2a62cab2a";

    public double[] getLocation(String sidoName, String stationName) {

        try {
            String redisKey = "LOC:" + sidoName + ":" + stationName;

            // ① Redis 캐시 우선 조회
            String cached = redisCacheService.get(redisKey);
            if (cached != null) {
                String[] parts = cached.split(",");
                return new double[]{
                    Double.parseDouble(parts[0]),
                    Double.parseDouble(parts[1])
                };
            }

            // ② 캐싱 없다면 Kakao API 호출
            String query = sidoName + " " + stationName;

            URI uri = UriComponentsBuilder
                    .fromUriString("https://dapi.kakao.com/v2/local/search/keyword.json")
                    .queryParam("query", query)
                    .encode(StandardCharsets.UTF_8)
                    .build()
                    .toUri();

            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            headers.set("Authorization", "KakaoAK " + KAKAO_API_KEY);

            org.springframework.http.HttpEntity<String> entity =
                    new org.springframework.http.HttpEntity<>("", headers);

            String json = restTemplate.exchange(uri,
                    org.springframework.http.HttpMethod.GET,
                    entity,
                    String.class).getBody();

            JsonNode root = objectMapper.readTree(json);
            JsonNode docs = root.path("documents");

            if (docs.isArray() && docs.size() > 0) {
                JsonNode first = docs.get(0);

                double lat = first.path("y").asDouble(); // 위도
                double lng = first.path("x").asDouble(); // 경도

                // ③ Redis 캐싱 (24시간)
                redisCacheService.set(redisKey, lat + "," + lng, 86400);

                return new double[]{lat, lng};
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new double[]{0.0, 0.0}; // 실패 시 항상 기본값
    }
}
