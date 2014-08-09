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

public class SDExplodeParticles extends GSimpleParticleSystem{
	public function SDExplodeParticles(p_node:GNode) {
		super(p_node);
		blendMode = GBlendMode.NORMAL;
		set_textureId("bonus_particle");

		emission = 100;
		emissionDelay = 0;
		emissionTime = 0.1;
		emissionVariance = 0;
		energy = 0.5;
		energyVariance = 0.2;
		dispersionAngle = 0;
		dispersionAngleVariance = 6.28;
		dispersionXVariance = 0;
		dispersionYVariance = 0;
		initialScale = 1;
		endScale = 1;
		initialScaleVariance = 0.5;
		endScaleVariance = 0;
		initialVelocity = 50;
		initialVelocityVariance = 0;
		initialAngularVelocity = 0;
		initialAngularVelocityVariance = 0;
		initialAcceleration = 0.5;
		initialAccelerationVariance = 0;
		initialAngle = 0;
		initialAngleVariance = 0;
		initialColor = 16777215;
		endColor = 16777215;
		initialAlpha = 1;
		initialAlphaVariance = 0;
		endAlpha = 0;
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

		Genome2D.getInstance().root.addChild(node);
		emit = true;
		burst = true;
	}
}
}
