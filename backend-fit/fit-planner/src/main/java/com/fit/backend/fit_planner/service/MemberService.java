package com.fit.backend.fit_planner.service;

import com.fit.backend.fit_planner.mapper.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MemberService {
  private final MemberMapper memberMapper;

}
