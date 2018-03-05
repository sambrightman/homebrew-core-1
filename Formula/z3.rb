class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.6.0.tar.gz"
  sha256 "511da31d1f985cf0c79b2de05bda4e057371ba519769d1546ff71e1304fe53c9"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "b8e7d05e007f45e7ac1d1962279db7f32043306441a984715842957e242683db" => :high_sierra
    sha256 "a0fcd87fa76072a7f8a6fb663c5d2589e8e1395e8c11acfb26150a7867aa6076" => :sierra
    sha256 "bc1f47e9c9c1bff59983a17e00b00ab6724de6c182147cbecd6115fea377fda8" => :el_capitan
    sha256 "b621a98c2eed48876783f0d95dfb6c688e79abfbc1798b1350ced61c3aeaeb10" => :x86_64_linux
  end

  option "without-python@2", "Build without python 2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python" => :optional

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    if build.without?("python") && build.without?("python@2")
      odie "z3: --with-python must be specified when using --without-python@2"
    end

    Language::Python.each_python(build) do |python, version|
      system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--python", "--pypkgdir=#{lib}/python#{version}/site-packages", "--staticlib"
      cd "build" do
        system "make"
        system "make", "install"
      end
    end

    # qprofdiff is not yet part of the source release (it will be as soon as a
    # version is released after 4.5.0), so we only include it in HEAD builds
    if build.head?
      system "make", "-C", "contrib/qprofdiff"
      bin.install "contrib/qprofdiff/qprofdiff"
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c",
      "-I#{include}", "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
  end
end
