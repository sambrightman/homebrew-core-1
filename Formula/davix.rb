class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
      :tag => "R_0_6_8",
      :revision => "7d9ae02fd29256399e72a400fc0a1f9af7c233d9"
  version "0.6.8"
  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "7266206226db685a5bab507dee4d2e69e213da29d3035d0f5dfe1d9159f4e5ce" => :mojave
    sha256 "81684262b74eb8206b2775e5387cb693ff3b8dc64cb08a7f556a105a27d9eb52" => :high_sierra
    sha256 "3870bc1e60426091f1a0631fdf36536a66c2b3772a6fc69cd4f91630b79693e7" => :sierra
    sha256 "f59c81532a3c82c01fc6b5743bd505eeee06f7c4369c7cf5f82e112aec66870e" => :el_capitan
    sha256 "1c50a3fbf4db045bd5b3f566ca9c7b39607da157de17a9df7fd23c6722bfd8cc" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl"
  if OS.mac?
    depends_on "ossp-uuid"
  else
    depends_on "libxml2"
    depends_on "util-linux" # for libuuid
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
