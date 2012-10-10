package {

    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;

    import mrwarp.GameConst;
    import mrwarp.GameRecord;
    import mrwarp.Assets;
    import mrwarp.scene.TitleScene;

    import tatsuyakoyama.tkframework.TkGameDirector;
    import tatsuyakoyama.tkframework.TkResourceManager;

    /**
     * Switch game scene.
     */
    //------------------------------------------------------------
    public class MrWarpGameDirector extends TkGameDirector {

        //------------------------------------------------------------
        public function MrWarpGameDirector() {
            Assets.initBmpFont();
            GameRecord.init();

            var titleScene:TitleScene = new TitleScene();
            startScene(titleScene);
        }

        /**
         * ゲームで使用する全ての texture atlas と sound のクラス情報を登録しておく。
         * 面倒だけどね、AS3 で Embed したいならこれは必要なことなんだ
         */
        protected override function onRegisterGameResources(resourceManager:TkResourceManager):void {
            resourceManager.registerTextureAtlasList([
                 [Assets.AtlasTex_Title,  Assets.AtlasXml_Title,  'atlas-title']
                ,[Assets.AtlasTex_01,     Assets.AtlasXml_01,     'atlas-01']
                ,[Assets.AtlasTex_02,     Assets.AtlasXml_02,     'atlas-02']
                ,[Assets.AtlasTex_Effect, Assets.AtlasXml_Effect, 'atlas-effect']
            ]);
            resourceManager.registerSoundClassList([
                 [Assets.Bgm_01, 'bgm-main']
                ,[Assets.SoundEffect_00, 'silent']
                ,[Assets.SoundEffect_01, 'title_select']
                ,[Assets.SoundEffect_02, 'move']
                ,[Assets.SoundEffect_03, 'enemy_die']
                ,[Assets.SoundEffect_04, 'player_damage']
                ,[Assets.SoundEffect_05, 'open_menu']
                ,[Assets.SoundEffect_06, 'pickup_item']
                ,[Assets.SoundEffect_07, 'enemy_damage']
            ]);
        }
    }
}
