// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: internal/pt/trace_warning.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

/// This file is auto-generated, DO NOT make any changes here

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct SAP_Internal_Pt_TraceWarningPackage {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// hours since UNIX Epoch
  var intervalNumber: UInt32 = 0

  var region: String = String()

  var timeIntervalWarnings: [SAP_Internal_Pt_TraceTimeIntervalWarning] = []

  var checkInProtectedReports: [SAP_Internal_Pt_CheckInProtectedReport] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SAP_Internal_Pt_TraceTimeIntervalWarning {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// SHA-256 of the Location ID
  var locationIDHash: Data = Data()

  /// 10-minute intervals since UNIX Epoch
  var startIntervalNumber: UInt32 = 0

  /// Number of 10-minute intervals to which the warning applies
  var period: UInt32 = 0

  var transmissionRiskLevel: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension SAP_Internal_Pt_TraceWarningPackage: @unchecked Sendable {}
extension SAP_Internal_Pt_TraceTimeIntervalWarning: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "SAP.internal.pt"

extension SAP_Internal_Pt_TraceWarningPackage: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TraceWarningPackage"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "intervalNumber"),
    2: .same(proto: "region"),
    3: .same(proto: "timeIntervalWarnings"),
    4: .same(proto: "checkInProtectedReports"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.intervalNumber) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.region) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.timeIntervalWarnings) }()
      case 4: try { try decoder.decodeRepeatedMessageField(value: &self.checkInProtectedReports) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.intervalNumber != 0 {
      try visitor.visitSingularUInt32Field(value: self.intervalNumber, fieldNumber: 1)
    }
    if !self.region.isEmpty {
      try visitor.visitSingularStringField(value: self.region, fieldNumber: 2)
    }
    if !self.timeIntervalWarnings.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.timeIntervalWarnings, fieldNumber: 3)
    }
    if !self.checkInProtectedReports.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.checkInProtectedReports, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_Pt_TraceWarningPackage, rhs: SAP_Internal_Pt_TraceWarningPackage) -> Bool {
    if lhs.intervalNumber != rhs.intervalNumber {return false}
    if lhs.region != rhs.region {return false}
    if lhs.timeIntervalWarnings != rhs.timeIntervalWarnings {return false}
    if lhs.checkInProtectedReports != rhs.checkInProtectedReports {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SAP_Internal_Pt_TraceTimeIntervalWarning: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TraceTimeIntervalWarning"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "locationIdHash"),
    2: .same(proto: "startIntervalNumber"),
    3: .same(proto: "period"),
    4: .same(proto: "transmissionRiskLevel"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.locationIDHash) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.startIntervalNumber) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.period) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.transmissionRiskLevel) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.locationIDHash.isEmpty {
      try visitor.visitSingularBytesField(value: self.locationIDHash, fieldNumber: 1)
    }
    if self.startIntervalNumber != 0 {
      try visitor.visitSingularUInt32Field(value: self.startIntervalNumber, fieldNumber: 2)
    }
    if self.period != 0 {
      try visitor.visitSingularUInt32Field(value: self.period, fieldNumber: 3)
    }
    if self.transmissionRiskLevel != 0 {
      try visitor.visitSingularUInt32Field(value: self.transmissionRiskLevel, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_Pt_TraceTimeIntervalWarning, rhs: SAP_Internal_Pt_TraceTimeIntervalWarning) -> Bool {
    if lhs.locationIDHash != rhs.locationIDHash {return false}
    if lhs.startIntervalNumber != rhs.startIntervalNumber {return false}
    if lhs.period != rhs.period {return false}
    if lhs.transmissionRiskLevel != rhs.transmissionRiskLevel {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
