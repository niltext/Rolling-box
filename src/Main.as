package {

    import laya.net.Loader;
    import laya.utils.Handler;
    import laya.webgl.WebGL;

    public class Main {

		public static var instance:Main;
		public function Main() {
			//初始化引擎
			Laya.init(1136, 640, WebGL);
			instance = this;
			Laya.loader.load([{url: "res/atlas/img.atlas", type: Loader.ATLAS}], Handler.create(this, onLoaded));
		}

        public var skillList:SkillList;
		private function onLoaded():void
		{
			skillList = new SkillList();
			Laya.stage.addChild(skillList);
		}
	}
}