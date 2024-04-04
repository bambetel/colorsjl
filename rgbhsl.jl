# Convert RGB color to HSL
# arguments: 0-255 R, G, B values
# returns H - degrees, S, L - percent
function rgbToHsl(R, G, B)
	r = R/255.0; g = G/255.0; b = B/255.0
	cmax = max(r, g, b)
	cmin = min(r, g, b)
	delta = cmax - cmin
	
	hue = 60 * if delta == 0 
			0 # undefined hue
		elseif  cmax == r 
			(g-b)/delta + 6
		elseif cmax == g 
			(b-r)/delta + 2
		else 
			(r-g)/delta + 4
		end

	lum = (cmax + cmin) / 2
	sat = if (delta == 0) 0 else delta / (1 - abs(2 * lum - 1)) end 

	return hue, sat, lum
end

function hslToRgb(H, S, L) 
	h = H/360.0
	s = S/100.0
	l = L/100.0

	if s == 0
		r = g = b = l
	else 
		q = if (l < 0.5) l * (1 + s) else l + s - l * s end
		p = 2 * l - q
		r = fromHsl(p, q, h + 1/3)
		g = fromHsl(p, q, h)
		b = fromHsl(p, q, h - 1/3)
	end

	return round(r*255.0), round(g*255.0), round(b*255.0)
end

function fromHsl(p, q, t) 
	if t < 0
		t += 1
	elseif t > 1 
		t -= 1
	end

	if (t < 1/6) return p + (q - p) * 6 * t end
	if (t < 1/2) return q end
	if (t < 2/3) return p + (q - p) * (2/3 - t) * 6 end

	return p	
end
