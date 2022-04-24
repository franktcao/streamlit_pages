import streamlit as st
from copy import deepcopy
import numpy as np

st.write("# Welcome, Frank!")
st.write("## How about now?")

ROWS = 3
COLS = 3


@st.cache(suppress_st_warning=True, allow_output_mutation=True)
def cached_thing():
    st.write("Long calculation...")
    return np.zeros((ROWS, COLS), dtype=int)

hi = cached_thing()
st.write(hi)
reset = st.button("reset")
add = st.button("add")
if reset:
    for row in range(ROWS):
        for col in range(COLS):
            hi[row, col] = 0
    # hi = deepcopy(np.zeros((ROWS, COLS), dtype=int))
elif add:
    hi[1, 1] += 20
st.write(hi)

cols = st.columns(4)
with cols[0]:
    st.checkbox("1", key="cb01")
    st.checkbox("1", key="cb02")
with cols[1]:
    st.checkbox("1", key="cb12")
with cols[2]:
    st.checkbox("1", key="cb23")
with cols[3]:
    st.checkbox("1", key="cb34")
