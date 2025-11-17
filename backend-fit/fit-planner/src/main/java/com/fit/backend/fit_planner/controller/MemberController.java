package com.fit.backend.fit_planner.controller;

import com.fit.backend.fit_planner.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping ("/member")
public class MemberController {
  private final MemberService memberService;

}
