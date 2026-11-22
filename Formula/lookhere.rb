# Homebrew formula for a personal tap (a GitHub repo named "homebrew-tap").
# It builds Lookhere from source on the user's Mac, so it needs no Apple Developer
# signing: locally built apps aren't quarantined by Gatekeeper.
#
# To release: tag github.com/silas-pohl/lookhere (e.g. v1.0.0), then update
# `url` and `sha256` here from
#   curl -L <tarball url> | shasum -a 256
class Lookhere < Formula
  desc "Cartoon pointer on a stick that pokes the screen every time you click"
  homepage "https://github.com/silas-pohl/lookhere"
  url "https://github.com/silas-pohl/lookhere/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "756c44463acf7dfb1cef480f48f2eba7a6c237dd09ec7796f90aeb04a1e8e791"
  license "MIT"
  head "https://github.com/silas-pohl/lookhere.git", branch: "main"

  # Swift comes with the Command Line Tools, which Homebrew already requires; no full Xcode needed.
  depends_on macos: :sonoma

  def install
    # SwiftPM's own sandbox can't nest inside Homebrew's build sandbox.
    system "./scripts/bundle.sh", "--disable-sandbox"
    prefix.install "build/Lookhere.app"
  end

  def caveats
    <<~EOS
      Lookhere.app is in:
        #{opt_prefix}/Lookhere.app

      Open it with:
        open #{opt_prefix}/Lookhere.app

      To have it in your Applications folder:
        ln -sf #{opt_prefix}/Lookhere.app ~/Applications/Lookhere.app
    EOS
  end

  test do
    output = shell_output("#{prefix}/Lookhere.app/Contents/MacOS/Lookhere --simulate")
    assert_match "total impacts: 6 for 6 clicks", output
  end
end
