class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/yyuu/pyenv"
  url "https://github.com/yyuu/pyenv/archive/v20160509.tar.gz"
  sha256 "84e63e1fa4e25a8b4c737d35a1af4c769e8ea12fdeb1bb2dc82f0f567e0f5a20"
  head "https://github.com/yyuu/pyenv.git"

  bottle :unneeded

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended
  depends_on "readline" => [:recommended, :run]

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.pyenv add to your profile:
      export PYENV_ROOT=#{var}/pyenv

    To enable shims and autocompletion add to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
