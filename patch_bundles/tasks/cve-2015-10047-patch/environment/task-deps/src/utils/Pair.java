package utils;


public class Pair<T, S> {

        private T x;
        private S y;

        public Pair(T x, S y) {
                this.x = x;
                this.y = y;
        }

        public T getX() {
                return x;
        }

        public void setX(T x) {
                this.x = x;
        }

        public S getY() {
                return y;
        }

        public void setY(S y) {
                this.y = y;
        }


}