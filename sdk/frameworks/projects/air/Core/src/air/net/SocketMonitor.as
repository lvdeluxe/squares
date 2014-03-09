﻿/*
ADOBE SYSTEMS INCORPORATED
Copyright � 2008 Adobe Systems Incorporated. All Rights Reserved.
 
NOTICE:   Adobe permits you to modify and distribute this file only in accordance with
the terms of Adobe AIR SDK license agreement.  You may have received this file from a
source other than Adobe.  Nonetheless, you may modify or distribute this file only in 
accordance with such agreement.
*/

package air.net
{
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.errors.IOError;
	
/**
 * A SocketMonitor object monitors availablity of a TCP endpoint.
 * 
 * <p platform="actionscript">This class is included in the aircore.swc file. 
 * Flash Builder loads this class automatically when you create a project for AIR.
 * The Flex SDK also includes this aircore.swc file, which you should include
 * when compiling the application if you are using Flex SDK.
 * </p>
 * 
 * <p platform="actionscript">In Adobe<sup>&#xAE;</sup> Flash<sup>&#xAE;</sup> Professional CS3,
 * this class is included in the ServiceMonitorShim.swc file. To use classes in the air.net package , 
 * you must first drag the ServiceMonitorShim component from the Components panel to the 
 * Library and then add the following <code>import</code> statement to your ActionScript 3.0 code:
 * </p>
 * 
 * <listing platform="actionscript">import air.net.~~;</listing>
 *
 * <p platform="actionscript">To use air.net package in Adobe<sup>&#xAE;</sup> Flash<sup>&#xAE;</sup> Professional (CS4 or higher): </p>
 *
 * <ol platform="actionscript">
 *	<li>Select the File &gt; Publish Settings command.</li>
 *	<li>In the Flash panel, click the Settings button for ActionScript 3.0. Select Library Path.</li>
 *	<li>Click the Browse to SWC File button. Browse to Adobe Flash CS<i>n</i>/AIK<i>n.n</i>/frameworks/libs/air/aircore.swc
 		file in the Adobe Flash Professional installation folder.</li>
 *	<li>Click the OK button.</li>
 *	<li>Add the following <code>import</code> statement to your ActionScript 3.0 code: <code>import air.net.~~;</code></li>
 * </ol>
 * 
 * <p platform="javascript">To use this class in JavaScript code, load the aircore.swf 
 * file, as in the following:</p>
 * 
 * <listing platform="javascript">&lt;script src="aircore.swf" type="application/x-shockwave-flash"&gt;</listing>
 * 
 * @playerversion AIR 1.0
*/
public class SocketMonitor extends ServiceMonitor
{
	/**
	 * Creates a SocketMonitor object for a specified TCP endpoint.
	 *
	 * <p>After creating a SocketMonitor object, the caller should call <code>start</code>
	 * to begin monitoring the status of the service.</p>
	 *
	 * <p>As with the Timer object, the caller should maintain a reference to the SocketMonitor
	 * object. Otherwise, the runtime deletes the object and monitoring ends.</p>
	 *
	 * @param host The host to monitor.
	 * @param port The port to monitor.
	 * 
	 * @playerversion AIR 1.0
	 */
	public function SocketMonitor(host:String, port:int)
	{
		super();
		
		_host = host;
		_port = port;
		
		/* Variable_socket can be null if createSocket is overridden in derived classes. 
		*  For example, subclass SecureSocketMonitor returns null when the SecureSocket API is not supported.
		*/
		if(!_socket) 
		{
			stop();
			return;
		}
		
		function cool(event:Event):void
		{
			// trace(event);
			available = true;
			try
			{
				_socket.close();
			}
			catch(e:IOError)
			{
				// if we were not open...there is nothing to worry about
			}
			connecting = false;
		}
		
		function uncool(event:Event):void
		{
			// trace(event);
			available = false;
			try
			{
				_socket.close();
			}
			catch(e:IOError)
			{
				// if we were not open...there is nothing to worry about
			}
			connecting = false;
		}
		
		_socket.addEventListener(Event.CONNECT, cool);
		_socket.addEventListener(IOErrorEvent.IO_ERROR, uncool);
		_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uncool);
	}
	
	private var connecting:Boolean = false;
	
	/**
	 * The host being monitored.
	 * 
	 * @playerversion AIR 1.0
	 */
	public function get host():String
	{
		return _host
	}
	
	private var _host:String;
	
	/**
	 * The port being monitored.
	 * 
	 * @playerversion AIR 1.0
	 */
	public function get port():int
	{
		return _port;
	}
	
	private var _port:int;
	
	/**
	* Calling the <code>checkStatus()</code> method of a SocketMonitor object causes
	* the application to try connecting to the socket, to check for a 
	* <code>connect</code> event.
	* 
	* @playerversion AIR 1.0
	*/
	protected override function checkStatus():void
	{
		if(!_socket) 
		{
			stop();
			return;
		}
		
		// trace('socket connect', _host, _port);
		
		// Thrashing around on the Socket.connect API spawns lots of threads.
		// So don't start a new one until the old one completes.
		if (connecting)
			return;
			
		connecting = true;
		_socket.connect(_host, _port);
	}
	
	/**
	 * @inheritDoc
	 * 
	 * @playerversion AIR 1.0
	 */
	public override function toString():String
	{
		return '[SocketMonitor host="' + _host + '" port="' + _port + 
			'" available="' + available  + '"]';
	}
	
	/**
	* Creates a Socket object. 
	* 
	* @return the Socket object to be used by this SocketMonitor.
	* 
	* @playerversion AIR 1.0
	*/
	protected function createSocket():Socket
	{
		return new Socket();
	}
	
	private var _socket:Socket = createSocket();
}
}
