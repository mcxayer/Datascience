from keras.models import load_model
from keras.utils import plot_model

# Remember to run 'pip install pydot' and 'pip install graphviz' before using this
# Also, remember to install the GraphViz binaries from https://graphviz.gitlab.io/_pages/Download/Download_windows.html

model = load_model("cnn_model.h5")

plot_model(model, to_file='cnn_model.png')