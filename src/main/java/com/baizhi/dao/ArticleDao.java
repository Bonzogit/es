package com.baizhi.dao;

import com.baizhi.entity.Article;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ArticleDao {
    @Insert("insert into article values(#{id},#{title},#{author},#{content},#{time})")
    public void add(Article article);

    @Select("select * from article")
    public List<Article> findAll();


}
