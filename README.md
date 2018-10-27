## LayaAir引擎实现技能盒滚动刷新
### 构思
    不使用引擎提供的遮罩(耗性能)，通过自定义绘制实现，优化性能，灵活可控

### 实现
	以一定速率对上下技能盒的UV进行变换，实现可见部分的动态绘制，模拟滚动的视觉效果
  ![img](https://github.com/niltext/Rolling-box/blob/master/laya/assets/0.gif)![img](https://github.com/niltext/Rolling-box/blob/master/laya/assets/1.gif)
