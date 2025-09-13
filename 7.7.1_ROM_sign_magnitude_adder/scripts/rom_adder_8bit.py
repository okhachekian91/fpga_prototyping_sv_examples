

sign_mag_i = 0
sign_mag_j = 0
sum        = 0

with open("sign_mag_addr_rom_8bit.data","w") as f:
      for i in range(0,255):
            for j in range(0,255):
                  if (i >= 128):
                        sign_mag_i = - 1 * (i - 128)
                  else:
                        sign_mag_i = i;
            
                  if (j >= 128):
                        sign_mag_j = - 1 * (j - 128)
                  else:
                        sign_mag_j = j;
            
                  sum = sign_mag_i + sign_mag_j
                  if (sum < 0):
                        if (sum <= - 128):
                              f.write("1" + f"{(abs(sum)-128):07b}" + "\n")
                        else:
                              f.write("1" + f"{abs(sum):07b}" + "\n")
                  else:
                        if (sum >= 128):
                              f.write(f"{abs(sum)-128:08b}"+ "\n")
                        else:
                              f.write(f"{abs(sum):08b}"+ "\n")
