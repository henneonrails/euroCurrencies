// swift-tools-version: 6.1
// Package.swift
import PackageDescription

let package = Package(
  name: "EuroCurrencies",
  platforms: [
    .iOS(.v15),
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "EuroCurrencies",
      targets: ["EuroCurrencies"]),
  ],
  targets: [
    .target(
      name: "EuroCurrencies",
      dependencies: []),
    .testTarget(
      name: "EuroCurrenciesTests",
      dependencies: ["EuroCurrencies"]),
  ]
)
