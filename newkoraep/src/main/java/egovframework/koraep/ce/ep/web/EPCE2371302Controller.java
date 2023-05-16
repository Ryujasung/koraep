package egovframework.koraep.ce.ep.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.EPCE2371302Service;

/**
 * 고지서취소요청내역조회 Controller
 * @author 이근표
 *
 */
@Controller
public class EPCE2371302Controller {

    @Resource(name = "epce2371302Service")
    private EPCE2371302Service epce2371302Service;     //실행이력조회 service

    /**
     * 실행이력조회 초기화면
     * @param request
     * @param model
     * @return
     * @
     */
    @RequestMapping(value = "/CE/EPCE2371302.do", produces = "application/text; charset=utf8")
    public String epce2371302(HttpServletRequest request, ModelMap model) {
        //언어구분 리스트 , 용어구분 리스트
        model =epce2371302Service.epce2371302_select(model,request);

        return "/CE/EPCE2371302";
    }

    /**
     * 고지서취소요청조회
     * @param inputMap
     * @param request
     * @return
     * @
     */
    @RequestMapping(value="/CE/EPCE2371302_19.do", produces="application/text; charset=utf8")
    @ResponseBody
    public String epce2371302_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
        return util.mapToJson(epce2371302Service.epce2371302_select2(inputMap, request)).toString();
    }

    /**
     * 고지서취소요청조회 상세조회
     * @param request
     * @param model
     * @return
     * @
     */
    @RequestMapping(value = "/CE/EPCE2371388.do", produces = "application/text; charset=utf8")
    public String epceEPCE3961264(HttpServletRequest request, ModelMap model) {
        return "/CE/EPCE2371388";
    }

    /**
     * 고지서취소요청조회 사유 팝업
     * @param inputMap
     * @param request
     * @return
     * @
     */
    @RequestMapping(value="/CE/EPCE2371302_191.do", produces="application/text; charset=utf8")
    @ResponseBody
    public String epce2371302_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
        return util.mapToJson(epce2371302Service.epce2371302_select3(inputMap, request)).toString();
    }
}