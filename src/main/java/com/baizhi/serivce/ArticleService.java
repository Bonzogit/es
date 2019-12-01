package com.baizhi.serivce;

import com.baizhi.entity.Article;

import java.io.IOException;

public interface ArticleService {
    public void add(Article article) throws IOException;

    public void update() throws IOException;
}
