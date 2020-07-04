class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  revision 7
  head "https://github.com/mcg1969/vecLibFort.git"

  bottle do
    cellar :any
    sha256 "bacc73e19f66c5b9cbd1436cbac4a6256a638724961bc17a79a844a0c5635712" => :catalina
    sha256 "a3d1f23a1ce7f3044b50ba81baf3c1ee058070baa33a7d2a8ea14827ac6d0650" => :mojave
    sha256 "072c7d553e857a6b4c760f921b9eb6281e7d91c5911f5257915bf6de8bdee97e" => :high_sierra
  end

  depends_on "gcc" # for gfortran
  depends_on :macos

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "tester.f90"
  end

  test do
    system "gfortran", "-o", "tester", "-O", pkgshare/"tester.f90",
                       "-L#{lib}", "-lvecLibFort"
    assert_match "SLAMCH", shell_output("./tester")
  end
end
