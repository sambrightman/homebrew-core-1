class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"
  revision 3

  bottle do
    cellar :any
    sha256 "e76e19d5bcf1a6eebae188846f5656b5f615771beed5748897f4eb0fabd3151b" => :mojave
    sha256 "25be689b9bca3cef2ee0cb647388200d25f045f651679ef8871b8a86100f9e43" => :high_sierra
    sha256 "11e169f340dc1f93fbb3c21a87c3aaa7d1242967ed11672663e6e827e622ef0d" => :sierra
    sha256 "b3f95569c5d67db9c9c1e9eeff670e8769bd5b40ebf1e170bd64be7e62b8e576" => :el_capitan
    sha256 "cfad6f50b6630939fc7f32a97d3f70d3233b3a960290105892648b525a8a9886" => :x86_64_linux
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
