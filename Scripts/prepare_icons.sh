#!/bin/sh

# Based on the original source below. Updated for iOS 8
# Source: https://gist.github.com/Lerg/b0a643a13f751747976f
# 
# Apple HIG: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/IconMatrix.html

base=$1

# iPad 2 and iPad mini (@1x)
convert "$base" -resize '76x76'     -unsharp 1x4 "Icon-76.png"
convert "$base" -resize '40x40'   -unsharp 1x4 "Icon-40x.png"
convert "$base" -resize '29x29'   -unsharp 1x4 "Icon-29x.png"

# iPad and iPad mini (@2x)
convert "$base" -resize '152x152'   -unsharp 1x4 "Icon-152.png"
convert "$base" -resize '80x80'   -unsharp 1x4 "Icon-80x.png"
convert "$base" -resize '58x58'   -unsharp 1x4 "Icon-58x.png"

# iPhone 6, iPhone 5 and iPhone 4s (@2x)
convert "$base" -resize '120x120'   -unsharp 1x4 "Icon-120x.png"
#convert "$base" -resize '80x80'   -unsharp 1x4 "Icon-80x.png"
#convert "$base" -resize '58x58'   -unsharp 1x4 "Icon-58x.png"

# iPhone 6 Plus (@3x)
convert "$base" -resize '180x180'   -unsharp 1x4 "Icon-180.png"
#convert "$base" -resize '120x120'   -unsharp 1x4 "Icon-120.png"
convert "$base" -resize '87x87'   -unsharp 1x4 "Icon-87x.png"

# App Store
convert "$base" -resize '1024x1024' -unsharp 1x4 "iTunesArtwork.png"