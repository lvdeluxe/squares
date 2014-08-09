/**
 * Created by lvdeluxe on 14-05-18.
 */
package deluxe.particles {
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.node.GNode;

public class BaseGestureParticles extends GSimpleParticleSystem{

	public function BaseGestureParticles(p_node:GNode) {
		super(p_node);
	}

	public function setEnergy(pEnergy:Number):void{
		energy = (pEnergy / 1000) * 1.1;
	}
}
}
