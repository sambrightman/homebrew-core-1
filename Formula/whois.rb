# whois: Build a bottle for Linuxbrew
class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.0.tar.xz"
  sha256 "3775ae0cfaa6dd8d886e5233c4826225cddcb88c99c2a08130d14e15fe58e378"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10059480020bd2630bedbcfc0b268992a2ba97a730fff1c9cd147672d17a7fab" => :mojave
    sha256 "189674db6b83258f70b76372c44ad0644497e65757ee5ed7004e576327f87797" => :high_sierra
    sha256 "69e7f9739c62cd476b297cfa2263be993970f4646d925db6e35c2b74fce76948" => :sierra
    sha256 "26f59ea7bad718ec91908b0a62023d1f1687150116dd1c6c811bb0196eb53048" => :x86_64_linux
  end

  option "with-libidn2", "Compile with IDN support"

  depends_on "libidn2" => :optional
  depends_on "pkg-config" => :build if build.with?("libidn2") || !OS.mac?

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    system "make", "whois", *(OS.mac? ? "HAVE_ICONV=1" : "HAVE_ICONV=0")
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  def caveats; <<~EOS
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
  EOS
  end

  test do
    system "#{bin}/whois", "brew.sh" if Pathname.new("/etc/services").readable?
  end
end
