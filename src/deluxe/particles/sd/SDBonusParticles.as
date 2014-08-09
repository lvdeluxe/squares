/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-27
 * Time: 21:44
 * To change this template use File | Settings | File Templates.
 */
package deluxe.particles.sd {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;
import com.genome2d.node.GNode;

public class SDBonusParticles extends GSimpleParticleSystem{
	public function SDBonusParticles(p_node:GNode) {
		super(p_node);
		blendMode = GBlendMode.NORMAL;
		set_textureId("bonus_particle");
		emission = 150;
		emissionDelay = 0;
		emissionTime = 1;
		emissionVariance = 0;
		energy = 0.75;
		energyVariance = 0.2;
		dispersionAngle = 6.28;
		dispersionAngleVariance = 6.28;
		dispersionXVariance = 0;
		dispersionYVariance = 0;
		initialScale = 1;
		endScale = 0;
		initialScaleVariance = 0.5;
		endScaleVariance = 0;
		initialVelocity = 75;
		initialVelocityVariance = 200;
		initialAngularVelocity = 0.003;
		initialAngularVelocityVariance = 0.01;
		initialAcceleration = -0.25;
		initialAccelerationVariance = 0.25;
		initialAngle = 1;
		initialAngleVariance = 0.5;
		initialColor = 16777215;
		endColor = 16777215;
		initialAlpha = 1;
		initialAlphaVariance = 0;
		endAlpha = 1;
		endAlphaVariance = 0;
		initialRed = 1;
		initialRedVariance = 0;
		endRed = 1;
		endRedVariance = 0;
		initialGreen = 1;
		initialGreenVariance = 0;
		endGreen = 1;
		endGreenVariance = 0;
		initialBlue = 1;
		initialBlueVariance = 0;
		endBlue = 1;
		endBlueVariance = 0;
//		node.transform.setPosition(568,320);
		Genome2D.getInstance().root.addChild(node);
		emit = true;
		burst = true;
	}
}
}
