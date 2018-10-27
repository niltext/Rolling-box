package
{
    import laya.display.Sprite;
    import laya.net.Loader;
    import laya.renders.RenderContext;
    import laya.resource.Texture;
    import laya.webgl.canvas.WebGLContext2D;

    public class SkillList extends Sprite
	{
		public function SkillList()
		{
			init(); //初始化，加载技能图集
            customRenderEnable = true;
		}

		private var deltaT:Number;
		private var deltaB:Number;
		private var idx:int;
		private var resultId:int; //最终停留技能盒id
		private var startTime:int; //开始滚动时间戳
		private var boxTexes:Array;
        private static var skillIds:Array = [0, 1, 2, 3, 4, 5]; //技能盒子id
        private function init():void
        {
			boxTexes = [];
            for (var i:int = 0; i < skillIds.length; i++)
            {
                boxTexes.push(Loader.getRes("img/s" + skillIds[i] + ".png"));
            }
			deltaT = 0;
			deltaB = 1;
			idx = 1;
			resultId = 0;
            newScroll(5); //开始滚动 最后停留在技能id为5的技能盒
//            trace(boxTexes);
        }

		//front: idx前一位的索引
		private static var front:int = 0;
        /**
		 * 循环绘制滚动盒子
         * @param ctx 绘图上下文
         * @param x 技能盒子x坐标
         * @param y 技能盒子y坐标
         * @param h 单个盒子的高度
         */
		private function scrollBox(ctx:WebGLContext2D, x:Number, y:Number, h:Number):void
		{
			if (Laya.timer.currTimer - startTime > 500 && ((deltaT > 1 || deltaB < 0) && resultId == idx))
			{
				drawImgT(ctx, boxTexes[resultId], x, y, 1, h, h);
//				trace("...end");
			}else{
//              trace("...idx: ",  idx, deltaT, deltaB);
                drawImgT(ctx, boxTexes[idx], x, y, deltaT, h * deltaT, h);
                drawImgB(ctx, boxTexes[front], x, y + h * deltaT, deltaB, h * deltaB, h);
				if (deltaT < 0 || deltaB < 0) //当完全滚入新的技能盒之后，更新索引
				{
					if (idx < boxTexes.length - 1)
					{
						idx += 1;
						front = idx - 1;
					}else {
						//当idx到达技能盒数组最后一位时 重新开始循环
						front = idx;
						idx = 0;
					}
					var temp:Number = deltaT;
					deltaT = deltaB;
					deltaB = temp;
				}

				deltaT += 0.05;
				deltaB -= 0.05;
			}
		}

        /**
		 * 绘制上方盒子
         */
		private static function drawImgT(ctx:WebGLContext2D, tex:Texture, x:Number, y:Number, srcHeight:Number, decHeight:Number, h:Number):void
		{
			tex.source;
			var preHeight:Number = tex.uv[7] - tex.uv[1];
			tex.uv[3] = tex.uv[1] = tex.uv[7] - preHeight * srcHeight;
			ctx.drawTexture(tex, x, y, h, decHeight, -h / 2, -h / 2);
			tex.uv[3] = tex.uv[1] = tex.uv[7] - preHeight;
		}

        /**
		 * 绘制下方盒子
         */
		private static function drawImgB(ctx:WebGLContext2D, tex:Texture, x:Number, y:Number, srcHeight:Number, decHeight:Number, h:Number):void
		{
			tex.source;
			var preHeight:Number = tex.uv[1] - tex.uv[7];
			tex.uv[7] = tex.uv[5] = tex.uv[1] - preHeight * srcHeight;
			ctx.drawTexture(tex, x, y, h, decHeight, -h / 2, -h / 2);
			tex.uv[7] = tex.uv[5] = tex.uv[1] - preHeight;
		}

        public var suspend:Boolean = true; //休眠 停止绘制
		public override function customRender(context:RenderContext, x:Number, y:Number):void
		{
//			if(suspend) return;
			var ctx:WebGLContext2D = context.ctx as WebGLContext2D;
			scrollBox(ctx, x + 100, y + 100, 100);
		}

        /**
         * 开始滚动
         * @param targetId 最终停留的技能盒id
         */
        public function newScroll(targetId:int):void
        {
            resultId = targetId;
            startTime = Laya.timer.currTimer;
        }
	}
}