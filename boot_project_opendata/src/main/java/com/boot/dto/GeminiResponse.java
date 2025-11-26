package com.boot.dto;

import lombok.Data;

@Data
public class GeminiResponse {

    private Candidate[] candidates;

    @Data
    public static class Candidate {
        private Content content;
    }

    @Data
    public static class Content {
        private Part[] parts;
    }

    @Data
    public static class Part {
        private String text;
    }
}
