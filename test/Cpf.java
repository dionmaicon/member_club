public final class Cpf {

    public static Boolean isValid(String cpf) {

        if(cpf == null || cpf.isEmpty()){
            return false;
        }
        
        cpf = cpf.replace(".", "").replace("-", "");

        if (cpf.equals("")) {
            return false;
        }

        if (cpf.length() != 11 || "00000000000".equals(cpf) || "11111111111".equals(cpf) || "22222222222".equals(cpf) || "33333333333".equals(cpf) || "44444444444".equals(cpf) || "55555555555".equals(cpf) || "66666666666".equals(cpf) || "77777777777".equals(cpf) || "88888888888".equals(cpf) || "99999999999".equals(cpf)) {
            return false;
        }

        int aux = 0;

        for (int i = 0; i < 9; i++) {
            aux += Character.getNumericValue(cpf.charAt(i)) * (10 - i);
        }

        int rev = 11 - (aux % 11);

        if (rev == 10 || rev == 11) {
            rev = 0;
        }

        if (rev != Character.getNumericValue(cpf.charAt(9))) {
            return false;
        }

        aux = 0;

        for (int i = 0; i < 10; i++) {
            aux += Character.getNumericValue(cpf.charAt(i)) * (11 - i);
        }

        rev = 11 - (aux % 11);

        if (rev == 10 || rev == 11) {
            rev = 0;
        }

        return rev == Character.getNumericValue(cpf.charAt(10));
    }

    public static String generateNew(final Boolean cpfWithDots) {
        String cpf;

        int n = 9;

        long n1 = randomize(n);
        long n2 = randomize(n);
        long n3 = randomize(n);
        long n4 = randomize(n);
        long n5 = randomize(n);
        long n6 = randomize(n);
        long n7 = randomize(n);
        long n8 = randomize(n);
        long n9 = randomize(n);

        long d1 = n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 * 9 + n1 * 10;

        d1 = 11 - (mod(d1, 11));

        if (d1 >= 10) {
            d1 = 0;
        }

        long d2 = d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 * 9 + n2 * 10 + n1 * 11;

        d2 = 11 - (mod(d2, 11));

        if (d2 >= 10) {
            d2 = 0;
        }

        if (cpfWithDots) {
            cpf = "" + n1 + n2 + n3 + "." + n4 + n5 + n6 + "." + n7 + n8 + n9 + "-" + d1 + d2;
        } else {
            cpf = "" + n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + d1 + d2;
        }

        return cpf;
    }

    private static long randomize(final int n) {
        return Math.round(Math.random() * n);
    }

    private static long mod(final long dividendo, final long divisor) {
        return Math.round(dividendo - (Math.floor(dividendo / divisor) * divisor));
    }
}
