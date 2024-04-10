using Test
using CSV
using DataFrames
include("rgbhsl.jl")

@test true

df = DataFrame(CSV.File("data1.csv", delim=' ', header=true))
res = rgbToHsl.(df.R, df.G, df.B)
res2 = hslToRgb.(df.H, df.S, df.L)

tolerance = 1.1
sameNr = (a, b, t) -> abs(a-b) <= t
same = (a, b) -> (sameNr(a[1], b[1], tolerance) && sameNr(a[2],b[2],tolerance) && sameNr(a[3],b[3],tolerance))

t = map(a->(a.ColorName, (a.H,a.S,a.L), rgbToHsl(a.R,a.G,a.B), (a.R,a.G,a.B), hslToRgb(a.H,a.S,a.L)), eachrow(df))
tt = map(x -> (x[1], same(x[2],x[3]), same(x[4], x[5])), t)
