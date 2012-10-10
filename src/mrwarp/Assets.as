package mrwarp {

    import flash.media.Sound;

    import starling.errors.AbstractClassError;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.text.BitmapFont;

    //------------------------------------------------------------
    public class Assets {

        //------------------------------------------------------------
        public function Assets() {
            // prohibit the instantiation of class
            throw new AbstractClassError();
        }

        /**
         * Register all bitmap font data used in game
         */
        public static function initBmpFont():void {
            var texture_01:Texture = Texture.fromBitmap(new BmpFontTex_01());
            var xml_01:XML = XML(new BmpFontXml_01());
            TextField.registerBitmapFont(new BitmapFont(texture_01, xml_01));

            var texture_02:Texture = Texture.fromBitmap(new BmpFontTex_02());
            var xml_02:XML = XML(new BmpFontXml_02());
            TextField.registerBitmapFont(new BitmapFont(texture_02, xml_02));

            var texture_03:Texture = Texture.fromBitmap(new BmpFontTex_03());
            var xml_03:XML = XML(new BmpFontXml_03());
            TextField.registerBitmapFont(new BitmapFont(texture_03, xml_03));
        }

        // BGM
        //------------------------------------------------------------
        [Embed(source="../../resource/bgm/mr_warp.mp3")]
        public static const Bgm_01:Class;

        // sound effect
        //------------------------------------------------------------
        [Embed(source="../../resource/sound/silent.mp3")]
        public static const SoundEffect_00:Class;

        [Embed(source="../../resource/sound/title_select.mp3")]
        public static const SoundEffect_01:Class;

        [Embed(source="../../resource/sound/move2.mp3")]
        public static const SoundEffect_02:Class;

        [Embed(source="../../resource/sound/enemy_die.mp3")]
        public static const SoundEffect_03:Class;

        [Embed(source="../../resource/sound/player_damage.mp3")]
        public static const SoundEffect_04:Class;

        [Embed(source="../../resource/sound/open_menu.mp3")]
        public static const SoundEffect_05:Class;

        [Embed(source="../../resource/sound/pickup_item.mp3")]
        public static const SoundEffect_06:Class;

        [Embed(source="../../resource/sound/enemy_damage.mp3")]
        public static const SoundEffect_07:Class;

        // texture atlas
        //------------------------------------------------------------
        [Embed(source="../../resource/img/atlas_title.png")]
        public static const AtlasTex_Title:Class;

        [Embed(source="../../resource/img/atlas_title.xml", mimeType="application/octet-stream")]
        public static const AtlasXml_Title:Class;

        [Embed(source="../../resource/img/atlas_01.png")]
        public static const AtlasTex_01:Class;

        [Embed(source="../../resource/img/atlas_01.xml", mimeType="application/octet-stream")]
        public static const AtlasXml_01:Class;

        [Embed(source="../../resource/img/atlas_02.png")]
        public static const AtlasTex_02:Class;

        [Embed(source="../../resource/img/atlas_02.xml", mimeType="application/octet-stream")]
        public static const AtlasXml_02:Class;

        [Embed(source="../../resource/img/atlas_effect.png")]
        public static const AtlasTex_Effect:Class;

        [Embed(source="../../resource/img/atlas_effect.xml", mimeType="application/octet-stream")]
        public static const AtlasXml_Effect:Class;

        // bitmap font
        //------------------------------------------------------------
        [Embed(source="../../resource/bmp_font/tk_courier_mini.fnt", mimeType="application/octet-stream")]
        private static const BmpFontXml_01:Class;

        [Embed(source = "../../resource/bmp_font/tk_courier_mini.png")]
        private static const BmpFontTex_01:Class;

        [Embed(source="../../resource/bmp_font/tk_courier.fnt", mimeType="application/octet-stream")]
        private static const BmpFontXml_02:Class;

        [Embed(source = "../../resource/bmp_font/tk_courier.png")]
        private static const BmpFontTex_02:Class;

        [Embed(source="../../resource/bmp_font/tk_mincho.fnt", mimeType="application/octet-stream")]
        private static const BmpFontXml_03:Class;

        [Embed(source = "../../resource/bmp_font/tk_mincho.png")]
        private static const BmpFontTex_03:Class;
    }
}

