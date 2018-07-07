<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js">
</script>
<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-star"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>


{% if theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span> 
  <span class="post-meta-item-icon"> <i class="fa fa-area-chart"></i></span> 
  <div class="theme-info">
    <div class="powered-by"></div>
    <span class="post-count">博客全站共{{ totalcount(site) }}字</span>
  </div>
    <div class="powered-by">
      <span class="post-meta-divider">|</span> 
        <i class="fa fa-user-md"></i>
       <span id="busuanzi_container_site_uv">  </span>
          本站访客数:
         <span id="busuanzi_value_site_uv"> </span>
     </div>
  <div class="powered-by">
      <span class="post-meta-divider">|</span>   
      <i class="fa fa-group"></i>
      <span style="float:right">本站总访问量：<span><span style="float:right" id="busuanzi_value_site_pv"></span>
  </div>
{# 结束 #}
{% endif %}



  <!--原底部统计设置-->
  <!-- {% if theme.post_wordcount.totalcount %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.post_wordcount.item_text %}
      <span class="post-meta-item-text">{{ __('post.totalcount') }}&#58;</span>
    {% endif %}
    <span title="{{ __('post.totalcount') }}">{#
    #}{{ totalcount(site, '0,0.0a') }}{#
  #}</span>
  {% endif %} 
  -->
</div>

{% if theme.footer.powered %}
  <div class="powered-by">{#
  #}{{ __('footer.powered', '<a class="theme-link" target="_blank" href="https://hexo.io">Hexo</a>') }}{#
#}</div>
{% endif %}

{% if theme.footer.powered and theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span>
{% endif %}


{% if theme.footer.custom_text %}
  <div class="footer-custom">{#
  #}{{ theme.footer.custom_text }}{#
#}</div>
{% endif %}
