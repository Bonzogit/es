package com.baizhi;

import com.baizhi.entity.Article;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;


public interface BookRepository extends ElasticsearchRepository<Article, String> {
}