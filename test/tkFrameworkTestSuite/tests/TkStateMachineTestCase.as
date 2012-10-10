package tkFrameworkTestSuite.tests {

    import org.flexunit.Assert;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkStateMachine;

    public class TkStateMachineTestCase {

        private var _state:TkStateMachine = new TkStateMachine();

        [Before]
        public function runBeforeTest():void {
            _state.initWithObj({
                idle: null,
                attack: {
                    shoot: {
                        rapid: null,
                        soft : null
                    },
                    tackle: null
                },
                defense: {
                    guard: null,
                    avoid: null
                },
                waitInit: null
            });
        }

        [Test]
        public function test_switchState_with_wrongState():void {
            try {
                _state.switchState('defense');
            } catch(e:Error) {
                Assert.assertEquals(true, true);
                return;
            }
            Assert.fail('switchState() must be failed with undefined state');
        }

        [Test]
        public function test_switchState_with_correctState():void {
            try {
                _state.switchState('defense.guard');
            } catch(e:Error) {
                Assert.fail('switchState() should work with defeined state');
            }
            Assert.assertEquals(true, true);
        }

        [Test]
        public function test_isState_1():void {
            _state.switchState('attack.shoot.rapid');
            Assert.assertEquals(true, _state.isState('attack.shoot.rapid'));
        }

        [Test]
        public function test_isState_2():void {
            _state.switchState('attack.shoot.soft');
            Assert.assertEquals(true, _state.isState('attack.shoot'));
        }

        [Test]
        public function test_isState_3():void {
            _state.switchState('attack.shoot.soft');
            Assert.assertEquals(true, _state.isState('attack'));
        }

        [Test]
        public function test_isState_4():void {
            _state.switchState('attack.shoot.soft');
            Assert.assertEquals(false, _state.isState('attack.tackle'));
        }
    }
}
