package egovframework.koraep.ce.ep.web;

import java.io.IOException;



import javax.servlet.Filter;

import javax.servlet.FilterChain;

import javax.servlet.FilterConfig;

import javax.servlet.ServletException;

import javax.servlet.ServletRequest;

import javax.servlet.ServletResponse;

import javax.servlet.http.HttpServletResponse;

public class SimpleCORSFilter implements Filter{
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {

        HttpServletResponse response = (HttpServletResponse) res;


 


        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");


 
        response.setHeader("Access-Control-Max-Age", "3600");

        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");

        

        response.setHeader("Access-Control-Allow-Origin", "*");  /*여기의 *을 내가 허용하고 싶은 특정 도메인으로 바꾸면 설정한 도메인에 한에서만 크로스 도메인을 허용하게된다. 여러 도메인의 경우 여러번 설정하면된다. */

     



        chain.doFilter(req, res);

    }

    public void init(FilterConfig filterConfig) {}

    public void destroy() {}


}
