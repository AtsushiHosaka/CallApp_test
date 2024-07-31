import Foundation
import AgoraRtcKit

class CallManager: NSObject, ObservableObject {
    
    // MARK: - Published properties
    @Published var isInCall: Bool = false
    @Published var isMuted: Bool = false
    @Published var isVideoEnabled: Bool = true
    @Published var remoteUid: UInt?
    @Published var joinChannelSuccess: Bool = false
    
    // MARK: - Private properties
    private var agoraEngine: AgoraRtcEngineKit?
    private let appId = "e7ce13b9864c4178a8020dd8e90e9d0d"
    private let token = "007eJxSYHj9s+LE5Kf7lrJZFJ0wllzG2210JP7JBdbt5cvXuOrkhgcqMKSaJ6caGidZWpiZJJsYmlskWhgYGaSkWKRaGqRaphikfBduTXNw4meYsHY6KyMDIwMLAyMDiM8EJpnBJAuULEktLmFgAAQAAP//yeYhmQ=="
    
    // MARK: - Initialization
    override init() {
        super.init()
        initializeAgoraEngine()
    }
    
    // MARK: - Private methods
    private func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        config.appId = appId
        
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        
        // Set audio session configuration to default
        agoraEngine?.setDefaultAudioRouteToSpeakerphone(true)
        
        // Enable video module
        agoraEngine?.enableVideo()
        
        // Set video configuration
        let videoConfig = AgoraVideoEncoderConfiguration(
            size: AgoraVideoDimension640x360,
            frameRate: .fps15,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative,
            mirrorMode: .auto
        )
        agoraEngine?.setVideoEncoderConfiguration(videoConfig)
    }
    
    // MARK: - Public methods
    func joinChannel(channelName: String) {
        let option = AgoraRtcChannelMediaOptions()
        option.clientRoleType = .broadcaster
        option.channelProfile = .communication
        
        let result = agoraEngine?.joinChannel(
            byToken: token,
            channelId: channelName,
            uid: 0,
            mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in
                print("Join channel success")
                self.isInCall = true
                self.joinChannelSuccess = true
            }
        )
        
        if let result = result {
            print("Join channel result: \(result)")
        }
    }
    
    func leaveChannel() {
        let result = agoraEngine?.leaveChannel(nil)
        if let result = result {
            print("Leave channel result: \(result)")
            isInCall = false
            joinChannelSuccess = false
            remoteUid = nil
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
        agoraEngine?.muteLocalAudioStream(isMuted)
    }
    
    func toggleVideo() {
        isVideoEnabled.toggle()
        agoraEngine?.enableLocalVideo(isVideoEnabled)
    }
    
    func switchCamera() {
        agoraEngine?.switchCamera()
    }
    
    // MARK: - View related methods
    func getVideoCanvas(for uid: UInt) -> AgoraRtcVideoCanvas {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        return videoCanvas
    }
}

// MARK: - AgoraRtcEngineDelegate
extension CallManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Local user joined with uid: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("Remote user joined with uid: \(uid)")
        DispatchQueue.main.async {
            self.remoteUid = uid
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("Remote user offline: \(uid), reason: \(reason)")
        DispatchQueue.main.async {
            if self.remoteUid == uid {
                self.remoteUid = nil
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("Warning occurred: \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Error occurred: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        print("Token will expire soon. Renewing token...")
    }
}
