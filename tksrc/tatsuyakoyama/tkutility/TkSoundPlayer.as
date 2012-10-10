package tatsuyakoyama.tkutility {

    /**
     * これは学生時代に書いたソース
     * 落ち着いたら書きなおす
     */

    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.media.SoundMixer;

    import flash.events.Event;

    public class TkSoundPlayer {

        public static const   LOOP_INFINITY:uint = 99999999; //こんだけ繰り返せば無限ループみたいなもんよね

        public var   muteMode:Boolean;

        private var   bgmChannel:SoundChannel = new SoundChannel();
        private var   seChannel :SoundChannel = new SoundChannel();
        private var   trans:SoundTransform = new SoundTransform();
        private var   volume:Number;
        private var   targetVolume:Number; //音量フェード時の目標値
        private var   deltaVolume:Number; //音量フェード時のきざみ幅
        private var   FadeMode:Boolean;

        private var _currentBgmSrc:Sound = null;
        private var _pausePosition:int = 0;

        //コンストラクタ ---------------------------------------------------------------
        public function TkSoundPlayer() {
            bgmChannel = null;
            seChannel  = null;
            volume = 1;
            FadeMode = false;
            muteMode = false;
        }

        //音量の設定 ---------------------------------------------------------------
        public function setVolume( vol:Number ):void {
            volume = vol;
            if( volume > 1 ) volume = 1;
            if( volume < 0 ) volume = 0;
            trans.volume = volume;
            SoundMixer.soundTransform = trans;
        }

        //ミュートモードの切り替え -----------------------------------------------------
        public function toggleMuteMode():void {
            muteMode = !muteMode;
            if( muteMode ){
                setVolume( 0 );
            } else {
                setVolume( 1 );
            }
        }

        //フェードイン・アウト開始 -----------------------------------------------------------
        public function startFade( _targetVolume:Number, time:uint ):void {
            targetVolume = _targetVolume;
            if( targetVolume > 1 ) targetVolume = 1;
            if( targetVolume < 0 ) targetVolume = 0;
            deltaVolume = (targetVolume - volume) / time;
            FadeMode = true;
        }

        //音量フェード用の更新処理 ----------------------------------------------------
        public function updateFade():void {

            if( !FadeMode ) return;
            if( deltaVolume <= 0  &&  volume <= targetVolume ) FadeMode = false;
            if( deltaVolume >  0  &&  volume >= targetVolume ) FadeMode = false;

            volume += deltaVolume;
            if( volume > 1 ) volume = 1;
            if( volume < 0 ) volume = 0;
            trans.volume = volume;
            SoundMixer.soundTransform = trans;

        }

        //BGMの再生 ---------------------------------------------------------------
        public function playBgm( src:Sound, vol:Number = 1, loops:int = 1,
                                 startTime:Number = 0 ):void {
            if( bgmChannel != null ) bgmChannel.stop();
            trans.volume = vol;
            bgmChannel = src.play( startTime, loops, trans );
            bgmChannel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
            _currentBgmSrc = src;
        }

        public function replayBgm():void {
            if (_currentBgmSrc == null) { return; }

            playBgm(_currentBgmSrc);
        }

        public function pauseBgm():void {
            if (bgmChannel == null) { return; }

            _pausePosition = bgmChannel.position;
            bgmChannel.stop();
        }

        public function resumeBgm():void {
            if (bgmChannel == null) { return; }

            playBgm(_currentBgmSrc, 1, 1, _pausePosition);
        }

        /**
         * Sound.play の loops に 1 より多い数を指定してループさせると、
         * 途中再開したときに再開位置からループし直してしまうようだ。
         * それでは困るので再生終了のコールバックで 0 位置から再生し直すようにする
         */
        private function _onSoundComplete(event:Event):void {
            replayBgm();
        }

        //SEの再生 ----------------------------------------------------------------
        public function playSe( src:Sound, vol:Number = 0.4, pan:Number = 0, loops:int = 0,
                                startTime:Number = 0 ):void {
            trans.pan = pan;
            trans.volume = vol;
            seChannel = src.play( startTime, loops, trans );
        }

        //再生中のサウンドを停止 -------------------------------------------------------
        public function stop( ):void {
            if( bgmChannel != null ){
                bgmChannel.stop();
                bgmChannel = null;
            }
            if( seChannel != null ){
                seChannel.stop();
                seChannel = null;
            }
        }
    }
}
