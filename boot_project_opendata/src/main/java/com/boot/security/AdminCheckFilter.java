package com.boot.security;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class AdminCheckFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String uri = request.getRequestURI();

        // /admin/** 요청이면 관리자 여부 체크
        if (uri.startsWith("/admin")) {

            boolean isAdmin = false;

            if (session != null) {
                Object flag = session.getAttribute("isAdmin");
                if (flag != null && flag.equals(true)) {
                    isAdmin = true;
                }
            }

            if (!isAdmin) {
                // 관리자 아님 → 접근 금지
                response.sendRedirect("/login?message=관리자만 접근 가능한 페이지입니다.");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
