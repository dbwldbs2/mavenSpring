package com.part3.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.part3.domain.BoardVO;
import com.part3.domain.Criteria;
import com.part3.mapper.BoardMapper;
import com.part4.domain.ReplyVO;
import com.part4.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replymapper;

	@Override
	public void register(BoardVO board) {
		// TODO Auto-generated method stub
		
		log.info("register..."+ board);
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
		// TODO Auto-generated method stub
		
		log.info("get..." + bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		// TODO Auto-generated method stub
		
		log.info("modify..." + board);
		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		// TODO Auto-generated method stub
		
		log.info("remove..." + bno);
		
		List<ReplyVO> rnoList = replymapper.getRnoList(bno);
		
		for(int i = 0; i < rnoList.size(); i++) {
			replymapper.delete(rnoList.get(i).getRno());
		}
		
		int isDeleted = mapper.delete(bno);
		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList() {
		// TODO Auto-generated method stub
		
		log.info("getList...");
		return mapper.getList();
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		// TODO Auto-generated method stub
		
		log.info("get List with criteria: " + cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
	
}
